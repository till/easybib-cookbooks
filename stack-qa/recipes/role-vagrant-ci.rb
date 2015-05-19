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

deploy_user_name = node['stack-qa'][deploy_role]['deploy_user']

# override deploy-user so it's only used by this recipe
node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)
  node.default['deploy'][app]['user'] = deploy_user_name
  node.default['deploy'][app]['group'] = deploy_user_name
  node.default['deploy'][app]['home'] = "/home/#{deploy_user_name}"
end

node['deploy'].each do |app, deploy|

  next unless allow_deploy(app, deployable_apps, deploy_role)

  easybib_deploy app do
    deploy_data deploy
    app app
  end

  deploy_user = get_deploy_user

  config_dir = "#{deploy_user['home']}/.config/easybib"

  directory config_dir do
    owner deploy_user['user']
    group deploy_user['group']
    mode '0755'
    action :create
    recursive true
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

end
