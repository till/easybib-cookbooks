include_recipe "nginx-lb::service"

# leave one for haproxy
if node["cpu"]["total"] > 1
  processes = (node["cpu"]["total"])-1
else
  processes = 1
end

# remove default virtualhost
file "#{node["nginx-lb"]["dir"]}/sites-enabled/default" do
  action :delete
  only_if do
    File.exists?("#{node["nginx-lb"]["dir"]}/sites-enabled/default")
  end
end

# write configuration and stop nginx
template "#{node["nginx-lb"]["dir"]}/nginx.conf" do
  owner  "root"
  group  "root"
  mode   "0644"
  source "nginx.conf.erb"
  variables(
    "processes" => processes
  )
  notifies :stop, "service[nginx]"
end
