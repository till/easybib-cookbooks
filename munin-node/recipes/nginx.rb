# prior to 10.04 we have to download them ourselves
munin_plugins = ["nginx_status", "nginx_request", "nginx_memory"]

include_recipe "munin-node::service"

directory "/opt/munin-nginx" do
  mode "0755"
end

remote_file "/opt/munin-nginx/nginx_memory" do
  source "http://exchange.munin-monitoring.org/plugins/nginx_memory/version/1/download"
  mode "0755"
end

remote_file "/opt/munin-nginx/nginx_status" do
  source "http://exchange.munin-monitoring.org/plugins/nginx_status/version/3/download"
  mode "0755"
end

remote_file "/opt/munin-nginx/nginx_request" do
  source "http://exchange.munin-monitoring.org/plugins/nginx_request/version/2/download"
  mode "0755"
end

munin_plugins.each do |plugin|
  link "/etc/munin/plugins/#{plugin}" do
    to "/opt/munin-nginx/#{plugin}"
  end
end

service "munin-node" do
  action :restart
end
