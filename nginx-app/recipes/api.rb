vagrant_dir = "/vagrant_data"

template "/etc/nginx/sites-enabled/silex.conf" do
  source "silex.conf.erb"
  mode   "0755"
  owner  node["nginx-app"][:user]
  group  node["nginx-app"][:group]
  variables(
    :php_user    => node["nginx-app"][:user],
    :doc_root    => vagrant_dir,
    :access_log  => 'off',
    :nginx_extra => 'sendfile  off;'
  )
  notifies :restart, resources(:service => "nginx"), :delayed
end
