deploy_role = node['stack-qa']['deploy_role']
deployable_apps = node['stack-qa'][deploy_role]['apps']

deploy_user_name = node['stack-qa'][deploy_role]['deploy_user']

# override deploy-user so it's only used by this recipe
node['deploy'].each do |app, deploy|
  next unless allow_deploy(app, deployable_apps, deploy_role)
  node.default['deploy'][app]['user'] = deploy_user_name
  node.default['deploy'][app]['group'] = deploy_user_name
  node.default['deploy'][app]['home'] = Dir.home(deploy_user_name)
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
end

if get_instance_roles.include?(deploy_role)
  node.default['easybib_vagrant']['environment'] = {
    'user' => deploy_user_name,
    'group' => deploy_user_name
  }

  include_recipe 'easybib_vagrant'

  # install public key to please keychain
  public_key = node['stack-qa'][deploy_role]['public_key']
  file "#{Dir.home(deploy_user_name)}/.ssh/id_dsa.pub" do
    content public_key
    mode 0644
    not_if do
      public_key.nil?
    end
  end

  node.default['bash']['environment'] = {
    'user' => deploy_user_name,
    'group' => deploy_user_name
  }
  include_recipe 'bash::profile'
end
