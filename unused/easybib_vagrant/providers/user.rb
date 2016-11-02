action :create do
  username = new_resource.username
  home_dir = new_resource.home_dir
  composer_token = new_resource.composer_token
  Chef::Log.info("easybib_vagrant_user: home_dir is #{home_dir}, user is #{username}")

  ['.config/easybib', '.ssh', '.vagrant.d'].each do |path|
    dir = "#{home_dir}/#{path}"
    directory dir do
      mode 0700
      owner username
      recursive true
    end
  end

  template "#{home_dir}/.ssh/config" do
    owner username
    cookbook 'easybib_vagrant'
    source 'ssh-config-opsworks.erb'
    mode 0600
    only_if { is_aws }
  end

  config = node['easybib_vagrant']['plugin_config']['bib-vagrant'].to_hash
  config['composer_github_token'] = composer_token

  template "#{home_dir}/.config/easybib/vagrantdefault.yml" do
    owner username
    cookbook 'easybib_vagrant'
    source 'vagrantdefault.yml.erb'
    variables(
      :config => config
    )
  end

  template "#{home_dir}/.vagrant.d/Vagrantfile" do
    owner username
    cookbook 'easybib_vagrant'
    source 'Vagrantfile.erb'
    mode 0644
  end

  node['easybib_vagrant']['plugin_config'].each_key do |plugin|
    execute "Install plugin: #{plugin}" do
      command "su #{username} -l -c 'bash vagrant plugin install #{plugin} 2>&1 | logger -t vagrant-ci-setup'"
    end
  end

  local_path = "#{home_dir}/easybib-cookbooks"
  git local_path do
    repository node['easybib_vagrant']['cookbooks']
    user username
    action :sync
  end

  template "#{home_dir}/.bash_profile" do
    source 'bash-profile.erb'
    cookbook 'easybib_vagrant'
    variables(
      :home_dir => home_dir
    )
    mode 0644
    owner username
  end

  new_resource.updated_by_last_action(true)

end
