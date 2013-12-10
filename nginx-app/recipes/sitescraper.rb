config = "sitescraper"

if is_aws()
  deploy_dir = "/srv/www/#{config}/current/www"
  nginx_extras = ""
else
  deploy_dir = "/vagrant_data/www"
  nginx_extras = "sendfile off;"
end

easybib_nginx config do
  config_template "internal-api.conf.erb"
  doc_root        deploy_dir
  access_log      'off'
  nginx_extras    nginx_extras
  routes_enabled  node["nginx-app"][config]["routes_enabled"]
  routes_denied   node["nginx-app"][config]["routes_denied"]
  notifies :restart, "service[nginx]", :delayed
end