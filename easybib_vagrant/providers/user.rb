action :create do
  username = new_resource.username
  home_dir = new_resource.home_dir
  composer_token = new_resource.composer_token

  home_dir = ::Dir.home(username) if home_dir.nil?

  ['.config/easybib', '.ssh', '.vagrant.d'].each do |path|
    dir = "#{home_dir}/#{path}"
    Chef::Log.info("DIR is #{dir}, user is #{username}")
    directory dir do
      mode 0700
      owner username
      recursive true
    end
  end

  template "#{home_dir}/.ssh/config" do
    owner username
    source 'ssh-config-opsworks.erb'
    mode 0600
    only_if { is_aws }
  end

  config = node['easybib_vagrant']['plugin_config']['bib-vagrant']
  config['composer_github_token'] = composer_token

  template "#{home_dir}/.config/easybib/vagrantdefault.yml" do
    owner username
    source 'vagrantdefault.yml.erb'
    variables(
      :config => config
    )
  end

  template "#{home_dir}/.vagrant.d/Vagrantfile" do
    owner username
    source 'Vagrantfile.erb'
    mode 0644
  end

  node['easybib_vagrant']['plugin_config'].each do |plugin,|
    execute "Install plugin: #{plugin}" do
      action :run
      command "vagrant plugin install #{plugin}"
      user username
    end
  end

  local_path = "#{home_dir}/easybib-cookbooks"
  git local_path do
    repository node['easybib_vagrant']['cookbooks']
    user username
    action :sync
  end
end
