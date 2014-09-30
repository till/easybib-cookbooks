deploy_user = get_deploy_user

# this is an assumption, so sue me
if deploy_user.is_a?(Hash)
  case deploy_user['user']
  when 'root'
    home_dir = '/root'
  when 'www-data'
    home_dir = '/var/www'
  else
    home_dir = "/home/#{deploy_user['user']}"
  end
end

directory "#{home_dir}/.composer" do
  owner     deploy_user[:user]
  group     deploy_user[:group]
  mode      '0750'
  recursive true
  only_if do
    ::EasyBib.is_aws(node)
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
  only_if do
    ::EasyBib.is_aws(node) && !node['composer']['oauth_key'].nil?
  end
end
