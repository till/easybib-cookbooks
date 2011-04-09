redis_version = node[:redis][:version]

remote_file "/tmp/redis-#{redis_version}.tar.gz" do
  source "http://redis.googlecode.com/files/redis-#{redis_version}.tar.gz"
  not_if do File.directory?("/tmp/redis-#{redis_version}") end
end

execute "tar xvfz /tmp/redis-#{redis_version}.tar.gz" do
  cwd    "/tmp"
  not_if do File.directory?("/tmp/redis-#{redis_version}") end
end

execute "make" do
  cwd "/tmp/redis-#{redis_version}"
end

execute "make install" do
  cwd "/tmp/redis-#{redis_version}"
end

if node[:redis][:user] != 'root'
  user "#{node[:redis][:user]}" do
    shell  "/bin/zsh"
    action :create
  end
end

directory node[:redis][:datadir] do
  owner     node[:redis][:user]
  group     "users"
  mode      "0755"
  recursive true
end

directory File.dirname(node[:redis][:log_file]) do
  action :create
  owner node[:redis][:user]
  group 'root'
  mode '0755'
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

service "redis-server" do
  service_name "redis-server"

  supports :status => false, :restart => true, :reload => false, "force-reload" => true
  action :enable
end

template "/etc/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis-server"), :immediately
end

template "/etc/logrotate.d/redis" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end

# include only when on scalarium
if node[:scalarium]
  include_recipe "redis::monit"
end
