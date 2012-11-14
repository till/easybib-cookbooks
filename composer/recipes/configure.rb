directory "/home/#{node[:scalarium][:deploy_user][:user]}/.composer" do
  owner node[:scalarium][:deploy_user][:user]
  group node[:scalarium][:deploy_user][:group]
  mode  "0750"
end

template "/home/#{node[:scalarium][:deploy_user][:user]}/.composer/config.json" do
  owner  node[:scalarium][:deploy_user][:user]
  group  node[:scalarium][:deploy_user][:group]
  source "composer.config.json.erb"
  mode   "0640"
  variables(
    :oauth_key => node["composer"]["oauth_key"]
  )
end
