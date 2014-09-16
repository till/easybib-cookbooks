include_recipe "nginx-lb::service"

nginx_config do
  cookbook "nginx-lb"
  enable_fastcgi false
  nginx_user node["nginx-lb"]["user"]
  nginx_group node["nginx-lb"]["user"]
  service_action :stop
end
