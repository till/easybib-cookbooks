if is_aws()
  deploy_dir = "/srv/www/bibcd/current/web"
  nginx_extras = ""
  default_router = "index.php"
else
  deploy_dir = "/vagrant_data/web/"
  nginx_extras = "sendfile off;"
  default_router = "index_dev.php"
end

config = "bibcd"

template "/etc/nginx/sites-enabled/#{config}.conf" do
  source "silex.conf.erb"
  mode   "0755"
  owner  node["nginx-app"]["user"]
  group  node["nginx-app"]["group"]
  variables(
    :php_user    => node["php-fpm"]["user"],
    :doc_root    => deploy_dir,
    :access_log  => 'off',
    :nginx_extra => nginx_extras,
    :default_router => default_router,
    :upstream => config,
    :db_conf => "",
    :domain_conf => ""
  )
  notifies :restart, resources(:service => "nginx"), :delayed
end
