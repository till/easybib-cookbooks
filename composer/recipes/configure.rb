if is_aws()

  deploy_user     = get_deploy_user()
  deploy_username = deploy_user[:user]
  deploy_group    = deploy_user[:group]

  # this is an assumption, so sue me
  case deploy_username
  when 'root'
    home_dir = '/root'
  when 'www-data'
    home_dir = '/var/www'
  else
    home_dir = "/home/#{deploy_username}"
  end

  directory "#{home_dir}/.composer" do
    owner     deploy_username
    group     deploy_group
    mode      "0750"
    recursive true
  end

  if node["composer"]
    template "#{home_dir}/.composer/config.json" do
      owner  deploy_username
      group  deploy_group
      source "composer.config.json.erb"
      mode   "0640"
      variables(
        :oauth_key => node["composer"]["oauth_key"]
      )
    end
  else
    Chef::Log.error('Configuration error, missing node["composer"]["oauth_key"]')
  end

else
  Chef::Log.debug("Recipe requires `aws` to be present.")
end
