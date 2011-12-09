redis_version = node[:redis][:version]

redis_version_installed = `#{node[:redis][:prefix]}/bin/redis-server -v | awk '{print $4}'`.strip

redis_already_installed = lambda do
  Chef::Log.debug("redis version installed: #{redis_version_installed}")
  Chef::Log.debug("redis version: #{redis_version}")
  redis_version_installed == redis_version
end

remote_file "/tmp/redis-#{redis_version}.tar.gz" do
  source "http://redis.googlecode.com/files/redis-#{redis_version}.tar.gz"
  not_if do File.directory?("/tmp/redis-#{redis_version}") end
end

execute "tar xvfz /tmp/redis-#{redis_version}.tar.gz" do
  cwd    "/tmp"
  not_if do File.directory?("/tmp/redis-#{redis_version}") end
end

execute "make" do
  cwd    "/tmp/redis-#{redis_version}"
  not_if &redis_already_installed
end

execute "make install" do
  cwd    "/tmp/redis-#{redis_version}"
  not_if &redis_already_installed
end

include_recipe "redis::user"

directory node[:redis][:datadir] do
  owner     node[:redis][:user]
  group     "users"
  mode      "0755"
  recursive true
end

directory File.dirname(node[:redis][:log_file]) do
  action :create
  owner  node[:redis][:user]
  group  'root'
  mode   '0755'
end

execute "chown #{node[:redis][:user]}:users redis-server redis-cli" do
  cwd "#{node[:redis][:prefix]}/bin"
end

template "/etc/init.d/redis-server" do
  source "redis.init.erb"
  owner  "root"
  group  "root"
  mode   "0755"
end

include_recipe "redis::service"
include_recipe "redis::configure"
