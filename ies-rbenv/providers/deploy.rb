action :install do
  rbenv_owner         = new_resource.rbenv_owner
  rbenv_group         = new_resource.rbenv_group
  rbenv_version       = new_resource.rbenv_version
  ruby_build_version  = new_resource.ruby_build_version
  rbenv_users         = new_resource.rbenv_users
  install_to          = new_resource.install_to
  ruby_opsworks       = new_resource.opsworks_ruby
  rubies              = new_resource.rubies
  gems                = new_resource.gems * ', '

  # Ensure that the rbenv install user and group exist and that the user is member of the group.
  user rbenv_owner do
    gid 50
  end

  group rbenv_group

  group rbenv_group do
    action :modify
    members rbenv_owner
    append true
  end

  # Ensure correct ownership of rbenv directory and set sticky bit
  directory install_to
  execute 'ensure correct ownership and set sticky bit' do
    command "chown -R #{rbenv_owner}:#{rbenv_group} #{install_to}; chmod g+rwxXs #{install_to}"
  end

  # Ensure that all rbenv users actually exist and have a gemrc file...
  rbenv_users.each do |rbenv_user|
    user rbenv_user do
      not_if do
        node.fetch('etc', {}).fetch('passwd', {}).fetch(rbenv_user, '')
      end
    end

    homedir = node['etc']['passwd'][rbenv_user]['dir']

    cookbook_file "#{homedir}/.gemrc" do
      cookbook 'ies-rbenv'
      source 'gemrc'
      user rbenv_user
      group rbenv_group
      mode '0600'
    end
  end

  # ... and that all rbenv users are member of the rbenv group as well.
  group rbenv_group do
    action :modify
    members rbenv_users
    append true
  end

  # Checkout desired version of rbenv.
  git install_to do
    repository 'https://github.com/rbenv/rbenv.git'
    revision rbenv_version
    user rbenv_owner
    group rbenv_group
    action :sync
  end

  # Ensure shims and versions directory
  directory "#{install_to}/shims"
  directory "#{install_to}/versions"

  # Compile rbenv Bash extensions for better overall performance of rbenv.
  execute 'compile rbenv bash extension' do
    command "cd #{install_to}/ && src/configure && make -C src"
    user rbenv_owner
    group rbenv_group
  end

  # rbenv requires specific environment variables, such as $PATH and $RBENV_ROOT.
  cookbook_file '/etc/profile.d/rbenv.sh' do
    cookbook 'ies-rbenv'
    source 'bashrc'
    user 'root'
    group 'root'
    mode '644'
  end

  # Ensure that the `rbenv` plugin directory exists.
  directory "#{install_to}/plugins" do
    user rbenv_owner
    group rbenv_group
    mode '0755'
    action :create
  end

  # Use rbenv plugin `ruby-build` to be able to install basically any Ruby version using rbenv.
  # https://github.com/rbenv/ruby-build
  git "#{install_to}/plugins/ruby-build" do
    repository 'https://github.com/rbenv/ruby-build.git'
    revision ruby_build_version
    user rbenv_owner
    group rbenv_group
    action :sync
  end

  # Install ruby-build to /usr/local
  execute 'install ruby-builder system-wide' do
    command "bash -l -c '#{install_to}/plugins/ruby-build/install.sh'"
    user 'root'
    group 'root'
  end

  # Ensure correct ownership of rbenv directory and set sticky bit
  directory install_to
  execute 'ensure correct ownership and permissions and set sticky bit' do
    command "chown -R #{rbenv_owner}:#{rbenv_group} #{install_to}; chmod g+rwxX #{install_to}"
  end

  # Install Ruby version required by OpsWorks
  if is_aws
    execute 'install opsworks mandatory ruby' do      # ~FC005
      command "bash -l -c '#{install_to}/bin/rbenv install -s #{ruby_opsworks}'"
      user rbenv_owner
      group rbenv_group
    end

    execute 'set ruby-version for OpsWorks as global default' do
      command "bash -l -c '#{install_to}/bin/rbenv global #{ruby_opsworks}'"
      user rbenv_owner
      group rbenv_group
    end
  else
    Chef::Log.info('No AWS detected, skipping installation of OpsWorks-mandatory Ruby!')
  end

  # Install all the desired Rubies and their gems
  rubies.each do |ruby_version|
    execute "install ruby-#{ruby_version}" do
      command "bash -l -c '#{install_to}/bin/rbenv install -s #{ruby_version}'"
      user rbenv_owner
      group rbenv_group
      only_if do
        ruby_version
      end
    end

    # Ensure correct ownership of all installed rubies.
    directory install_to
    execute 'rly ensure correct ownership and permissions and set sticky bit' do
      command "chown -R #{rbenv_owner}:#{rbenv_group} #{install_to}; chmod -R g+w #{install_to}/versions"
    end

    execute "install gems: #{gems}" do
      command "bash -l -c 'RBENV_VERSION=#{ruby_version} gem install #{gems}'"
      user rbenv_owner
      group rbenv_group
    end
  end

  new_resource.updated_by_last_action(true)
end
