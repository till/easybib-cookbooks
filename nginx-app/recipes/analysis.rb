#directory "#{node[:deploy][:deploy_to]}" do
#  owner  node["nginx-app"][:user]
#  group  node["nginx-app"][:group]
#  action :create
#end

if !node[:deploy]
  node[:deploy] = {}
  node[:deploy][:deploy_to] = '/var/www/citationalysis'
end

vagrant_dir = "/vagrant_data"

directory "#{node[:deploy][:deploy_to]}" do
  mode      "0755"
  action    :create
  recursive true
end

link "#{node[:deploy][:deploy_to]}/current" do
  to "#{vagrant_dir}"
end

template "/etc/nginx/sites-enabled/easybib.com.conf" do
  source "easybib.com.conf.erb"
  mode "0755"
  owner node["nginx-app"][:user]
  group node["nginx-app"][:group]
  variables :deploy => node[:deploy], :application => "easybib"
  notifies :restart, resources(:service => "nginx"), :delayed
end
