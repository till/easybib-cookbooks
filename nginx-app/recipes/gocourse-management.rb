config = "management"

if is_aws()
  deploy_dir = "/srv/www/#{config}/current/public/"
  domain_name = node["gocourse"]["domain"]["management"]
else
  deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  domain_name = ""
end

db_conf = get_db_conf("gocourse")
domain_conf = get_domain_conf("gocourse")

template "/etc/nginx/sites-enabled/#{config}.conf" do
  source "silex.conf.erb"
  mode   "0755"
  owner  node["nginx-app"]["user"]
  group  node["nginx-app"]["group"]
  variables(
    :php_user => node["php-fpm"]["user"],
    :doc_root => deploy_dir,
    :domain_name => domain_name,
    :access_log => 'off',
    :nginx_extra => node["nginx-app"]["extras"],
    :default_router => node["nginx-app"]["default_router"],
    :xhprof_enable => false,
    :upstream => config,
    :db_conf => db_conf,
    :domain_conf => domain_conf
  )
  notifies :restart, "service[nginx]", :delayed
end
