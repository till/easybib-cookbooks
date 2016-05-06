def rbenv_user
  @rbenv_user ||= new_resource.rbenv_user
  @rbenv_user ||= 'root'
end

def home
  @home ||= node['etc']['passwd'][rbenv_user]['dir']
end

def rbenv_home
  @rbenv_home ||= "#{home}/.rbenv"
end

def rbenv_revision
  @rbenv_revision ||= new_resource.rbenv_revision
  @rbenv_revision ||= 'master'
end

def ruby_build_revision
  @ruby_build_revision ||= new_resource.ruby_build_revision
  @ruby_build_revision ||= 'master'
end

def opsworks_mandatory_ruby
  @opsworks_mandatory_ruby ||= new_resource.opsworks_mandatory_ruby
end

action :install do
  desired_ruby = new_resource.desired_ruby

  if Dir.exist?("#{rbenv_home}/versions/#{desired_ruby}")
    Chef::Log.info("#{desired_ruby} is already installed, skipping!")
    next
  end

  # Use `rbenv` to manage multiple Ruby versions.
  # https://github.com/rbenv/rbenv
  git rbenv_home do
    repository 'https://github.com/rbenv/rbenv.git'
    revision rbenv_revision
    user rbenv_user
    group rbenv_user
    action :sync
  end

  # Ensure that the `rbenv` plugin directory exists.
  directory "#{rbenv_home}/plugins" do
    user rbenv_user
    group rbenv_user
    mode '0755'
    action :create
  end

  # Use rbenv plugin `ruby-build` to be able to install basically any Ruby version using rbenv.
  # https://github.com/rbenv/ruby-build
  git "#{rbenv_home}/plugins/ruby-build" do
    repository 'https://github.com/rbenv/ruby-build.git'
    revision ruby_build_revision
    user rbenv_user
    group rbenv_user
    action :sync
  end

  # Compile rbenv Bash extensions for better overall performance of rbenv.
  execute 'compile rbenv bash extension' do
    command "cd #{rbenv_home}/ && src/configure && make -C src"
    user rbenv_user
    group rbenv_user
  end

  # rbenv requires specific environment variables, such as $PATH.
  cookbook_file '/etc/profile.d/rbenv.sh' do
    cookbook 'ies-ruby'
    source 'bashrc'
    user 'root'
    group 'root'
    mode '644'
  end

  execute 'install opsworks mandatory ruby' do      # ~FC005
    command "su #{rbenv_user} -l -c '#{rbenv_home}/bin/rbenv install #{opsworks_mandatory_ruby}'"
    not_if do
      Dir.exist?("#{rbenv_home}/versions/#{opsworks_mandatory_ruby}")
    end
  end

  execute 'set ruby-version for OpsWorks as global default' do
    command "su #{rbenv_user} -l -c '#{rbenv_home}/bin/rbenv global #{opsworks_mandatory_ruby}'"
  end

  execute 'install desired ruby-version' do
    command "su #{rbenv_user} -l -c '#{rbenv_home}/bin/rbenv install #{desired_ruby}'"
    not_if do
      Dir.exist?("#{rbenv_home}/versions/#{desired_ruby}")
    end
  end

  execute 'install bundler' do
    command "su #{rbenv_user} -l -c '#{home}/.rbenv/versions/#{desired_ruby}/bin/gem install bundler'"
    environment('PATH' => path, 'HOME' => home, 'USER' => rbenv_user)
  end

  new_resource.updated_by_last_action(true)
end

action :remove do
  directory rbenv_home.to_s do
    action :delete
  end

  cookbook_file '/etc/profile.d/rbenv.sh' do
    source 'bashrc'
    action :delete
  end

  new_resource.updated_by_last_action(true)
end

action :reinstall do
  desired_ruby = new_resource.desired_ruby

  ies_ruby_rubies desired_ruby do
    action :remove
  end

  ies_ruby_rubies desired_ruby do
    action :install
  end

  new_resource.updated_by_last_action(true)
end
