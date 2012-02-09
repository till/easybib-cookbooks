if !node[:deploy]
  raise Chef::Exceptions::ConfigurationError, "node[:deploy] needs to be set."
end

if !node[:docroot]
  node[:docroot] = 'www'
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
  mode   "0755"
  owner  node["nginx-app"][:user]
  group  node["nginx-app"][:group]
  variables(
    :deploy      => node[:deploy],
    :application => "easybib",
    :access_log  => 'off'
  )
  notifies :restart, resources(:service => "nginx"), :delayed
end
