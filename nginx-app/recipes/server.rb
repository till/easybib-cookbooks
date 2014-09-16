include_recipe "nginx-app::ppa"
include_recipe "nginx-app::service"

ohai "reload_passwd" do
  action :nothing
  plugin "passwd"
end

package "nginx" do
  notifies :reload, "ohai[reload_passwd]", :immediately
  notifies :enable, "service[nginx]"
  notifies :start, "service[nginx]"
end

nginx_app_config "nginx-app: nginx.conf"
