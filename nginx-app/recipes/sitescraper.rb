config = "sitescraper"

easybib_nginx config do
  config_template "internal-api.conf.erb"
  doc_root        "www"
  access_log      "off"
  nginx_extras = "sendfile off;"
  routes_enabled  node["nginx-app"][config]["routes_enabled"]
  routes_denied   node["nginx-app"][config]["routes_denied"]
  notifies :restart, "service[nginx]", :delayed
end
