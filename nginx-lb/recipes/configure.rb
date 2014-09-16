include_recipe "nginx-lb::service"

nginx_app_config "nginx-lb: nginx.conf" do
  cookbook "nginx-lb"
  enable_fastcgi false
  nginx_user node["nginx-lb"]["user"]
  nginx_group node["nginx-lb"]["user"]
  notifies :stop, "service[nginx]"
end
