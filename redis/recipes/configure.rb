include_recipe "redis::service"

directory "/etc/redis" do
  user node["redis"]["user"]
  mode "0755"
end

template "/etc/redis/redis.conf" do
  source "redis.conf.erb"
  owner  node["redis"]["user"]
  mode   "0644"
  notifies :restart, "service[redis-server]", :immediately
end

template "/etc/logrotate.d/redis" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end
