include_recipe 'easybib::role-generic'
include_recipe 'virtualbox'
include_recipe 'vagrant'
include_recipe 'supervisor'

deploy_role = 'vagrant-ci'
deployable_apps = node['stack-qa'][deploy_role]['apps']

deploy_user_name = node['stack-qa'][deploy_role]['deploy_user']

# override deploy-user so it's only used by this recipe
node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)
  node.default['deploy'][app]['user'] = deploy_user_name
  node.default['deploy'][app]['group'] = deploy_user_name
  node.default['deploy'][app]['home'] = "/home/#{deploy_user_name}"
end

execute 'fix-home-dir' do
  command "chown -R #{deploy_user_name}:#{deploy_user_name} /home/#{deploy_user_name}"
  user 'root'
  action :nothing
end

node['deploy'].each do |app, deploy|

  next unless allow_deploy(app, deployable_apps, deploy_role)

  easybib_deploy app do
    deploy_data deploy
    app app
    notifies :run, 'execute[fix-home-dir]', :immediately
  end

  config_dir = "#{deploy['home']}/.config/easybib"

  directory config_dir do
    owner deploy['user']
    group deploy['group']
    mode '0755'
    action :create
    recursive true
  end

  # this has to be in this loop so we can access deploy and only do this
  # when apps are actually deployed ;)
  template "#{config_dir}/vagrantdefault.yml" do
    owner deploy['user']
    group deploy['group']
    source 'vagrantdefault.yml.erb'
    variables(
      :config => node['stack-qa'][deploy_role]['plugin_config']['bib-vagrant']
    )
  end

  # ensure the user has access to the cookbooks used by the server
  group "Add #{deploy_user_name} to 'aws'" do
    append true
    group_name 'aws'
    members [deploy_user_name]
    action :manage
  end

end

node['stack-qa'][deploy_role]['plugins'].each do |plugin|
  execute "Install plugin: #{plugin}" do
    action :run
    command "vagrant plugin install #{plugin}"
    user deploy_user_name
    group deploy_user_name
    environment('HOME' => "/home/#{deploy_user_name}",
                'USER' => deploy_user_name)
  end
end
