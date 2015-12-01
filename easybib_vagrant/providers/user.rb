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
