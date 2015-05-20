deploy_role = node['stack-qa']['deploy_role']
deployable_apps = node['stack-qa'][deploy_role]['apps']

deploy_user_name = node['stack-qa'][deploy_role]['deploy_user']

# override deploy-user so it's only used by this recipe
node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)
  node.default['deploy'][app]['user'] = deploy_user_name
  node.default['deploy'][app]['group'] = deploy_user_name
  node.default['deploy'][app]['home'] = ::Dir.home(deploy_user_name)
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

  # ensure the user has access to the cookbooks used by the server
  group "Add #{deploy['user']} to 'aws'" do
    append true
    group_name 'aws'
    members [deploy['user']]
    action :manage
  end
end

if get_instance_roles.include?(deploy_role)
  node.default['easybib_vagrant']['environment'] = {
    'user' => deploy_user_name,
    'group' => deploy_user_name
  }

  include_recipe 'easybib_vagrant'
end
