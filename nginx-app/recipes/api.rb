if is_aws()
  deploy_dir = "/srv/www/api/current/web"
else
  deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
end

config = "easybib_api"

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
    :xhprof_enable => node["nginx-app"]["xhprof"]["enable"],
    :upstream => config,
    :db_conf => "",
    :domain_conf => ""
  )
  notifies :restart, "service[nginx]", :delayed
end
