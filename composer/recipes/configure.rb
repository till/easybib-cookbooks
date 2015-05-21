deploy_user = node['composer']['environment']

Chef::Log.info("HELLO #{deploy_user['user']}")

return if deploy_user['user'].nil?

home_dir = Dir.home(deploy_user['user'])

directory "#{home_dir}/.composer" do
  owner     deploy_user[:user]
  group     deploy_user[:group]
  mode      '0750'
  recursive true
  not_if do
    node['composer']['oauth_key'].nil?
  end
end

template "#{home_dir}/.composer/config.json" do
  owner  deploy_user[:user]
  group  deploy_user[:group]
  source 'composer.config.json.erb'
  mode   '0640'
  variables(
    :oauth_key => node['composer']['oauth_key']
  )
  not_if do
    node['composer']['oauth_key'].nil?
  end
end
