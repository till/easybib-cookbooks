include_recipe 'easybib::role-generic'
include_recipe 'virtualbox'
include_recipe 'vagrant'
include_recipe 'supervisor'

deploy_role = 'vagrant-ci'
deployable_apps = node['stack-qa'][deploy_role]['apps']

node['stack-qa'][deploy_role]['plugins'].each do |plugin|
  vagrant_plugin plugin do
    action :install
  end
end

node['deploy'].each do |app, deploy|

  next unless allow_deploy(app, deployable_apps, deploy_role)

  deploy_user = get_deploy_user

  config_dir = "#{deploy_user['home']}/.config/easybib"

  directory config_dir do
    owner deploy_user['user']
    group deploy_user['group']
    mode '0755'
    action :create
    recursive true
  end

  # assuming we use the same key for each app
  file "#{deploy_user['home']}/.ssh/id_rsa" do
    content deploy['scm']['ssh_key']
    owner deploy_user['user']
    group deploy_user['group']
    mode 0600
  end

  # this has to be in this loop so we can access deploy and only do this
  # when apps are actually deployed ;)
  template "#{config_dir}/vagrantdefault.yml" do
    owner deploy_user['user']
    group deploy_user['group']
    source 'vagrantdefault.yml.erb'
    variables(
      :config => node['stack-qa'][deploy_role]['plugin_config']['bib-vagrant']
    )
  end

  easybib_deploy app do
    deploy_data deploy
    app app
  end

end
