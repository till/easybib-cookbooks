include_recipe "redis::configure"

template "/etc/redis/redis.conf" do
  source "redis.conf.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  notifies :restart, resources(:service => "redis-server"), :immediately
end

template "/etc/logrotate.d/redis" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end
