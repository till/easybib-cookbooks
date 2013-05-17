if is_aws()
  deploy_dir = "/srv/api/current"
  nginx_extras = ""
else
 deploy_dir = "/vagrant_data/web/"
 nginx_extras = "sendfile off;"
end

template "/etc/nginx/sites-enabled/silex.conf" do
  source "silex.conf.erb"
  mode   "0755"
  owner  node["nginx-app"][:user]
  group  node["nginx-app"][:group]
  variables(
    :php_user    => node["php-fpm"][:user],
    :doc_root    => deploy_dir,
    :access_log  => 'off',
    :nginx_extra => nginx_extras
  )
  notifies :restart, resources(:service => "nginx"), :delayed
end
