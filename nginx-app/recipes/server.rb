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

include_recipe "nginx-app::service"

template "/etc/nginx/fastcgi_params" do
  source "fastcgi_params.erb"
  mode "0755"
  owner node["nginx-app"]["user"]
  group node["nginx-app"]["group"]
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode "0755"
  owner node["nginx-app"]["user"]
  group node["nginx-app"]["group"]
  variables(
    :nginx_user => node["nginx-app"]["user"]
  )
end

execute "delete default vhost" do
  ignore_failure true
  command "rm -f /etc/nginx/sites-enabled/default"
end
