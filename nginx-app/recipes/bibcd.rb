if is_aws()
  deploy_dir = "/srv/www/bibcd/current/web"
else
  deploy_dir = "/vagrant_data/web/"
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
    :nginx_extra => node["nginx-app"]["extras"],
    :default_router => node["nginx-app"]["default_router"],
    :upstream => config,
    :db_conf => "",
    :domain_conf => ""
  )
  notifies :restart, "service[nginx]", :delayed
end
