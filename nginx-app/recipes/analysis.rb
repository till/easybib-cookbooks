#directory "#{node[:deploy][:deploy_to]}" do
#  owner  node["nginx-app"][:user]
#  group  node["nginx-app"][:group]
#  action :create
#end

if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/vagrant_data'
end

template "/etc/nginx/sites-enabled/easybib.com.conf" do
  source "easybib.com.conf.erb"
  mode "0755"
  owner node["nginx-app"][:user]
  group node["nginx-app"][:group]
  variables :deploy => node[:deploy], :application => "easybib"
  notifies :restart, resources(:service => "nginx"), :delayed
end
