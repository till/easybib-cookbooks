if node[:scalarium]

  deploy_username = node[:scalarium][:deploy_user][:user]
  deploy_group    = node[:scalarium][:deploy_user][:group]

  # this is an assumption, so sue me
  home_dir = "/home/#{deploy_username}"

  # copied this from scalarium's deploy/definition/scalarium_deploy_user.rb
  user deploy_username do
    action   :create
    comment  "deploy user"
    gid      deploy_group
    supports :manage_home => true
    shell    node[:scalarium][:deploy_user][:shell]
    home     home_dir
    not_if do
      existing_usernames = []
      Etc.passwd {|user| existing_usernames << user['name']}
      existing_usernames.include?(deploy_username)
    end
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
  Chef::Log.debug("Recipe requires `scalarium` to be present.")
end
