config = "management"

if is_aws
  deploy_dir = "/srv/www/#{config}/current/public/"
else
  if node["vagrant"]["combined"] == true
    deploy_dir = node["vagrant"]["deploy_to"][config]
  else
    deploy_dir = node["nginx-app"]["vagrant"]["deploy_dir"]
  end
end

domain_name = node["getcourse"]["domain"]["management"]
domain_conf = get_domain_conf("getcourse")

env_conf = ""
if has_env?("getcourse")
  env_conf = get_env_for_nginx("getcourse")
end

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
    :upstream => config,
    :env_conf => env_conf
  )
  notifies :restart, "service[nginx]", :delayed
end
