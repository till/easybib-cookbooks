include_recipe "nginx-app::ppa"

package "nginx"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/default/nginx" do
  source "default.erb"
  mode "0644"
  notifies :restart, resources( :service => "nginx")
end

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
end

execute "delete default vhost" do
  ignore_failure true
  command "rm -f /etc/nginx/sites-enabled/default"
end

