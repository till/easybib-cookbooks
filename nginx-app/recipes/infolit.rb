# this is for vagrant
link "#{node[:deploy][:deploy_to]}/current" do
  to "/vagrant_data"
end
  
template "/etc/nginx/sites-enabled/easybib.com.conf" do
  source "infolit.conf.erb"
  mode   "0755"
  owner  node["nginx-app"][:user]
  group  node["nginx-app"][:group]
  variables(
    :deploy      => node[:deploy],
    :application => "easybib",
    :access_log  => '/var/log/nginx/access.log',
    :nginx_extra => 'sendfile  off;'
  )
  notifies :restart, resources(:service => "nginx"), :delayed
end
