include_recipe "nginx-lb::service"

# leave one for haproxy
if node[:cpu][:total] > 1
  processes = (node[:cpu][:total])-1
else
  processes = 1
end

template "/etc/nginx/nginx.conf" do
  owner  "root"
  group  "root"
  mode   "0644"
  source "nginx.conf.erb"
  variables(
    "processes" => processes
  )
  notifies :restart, resources(:service => "nginx")
end
