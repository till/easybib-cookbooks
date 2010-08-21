remote_file "/tmp/redis-#{node[:redis][:version]}.tar.gz" do
  source "http://redis.googlecode.com/files/redis-#{node[:redis][:version]}.tar.gz"
end

execute "tar xvfz /tmp/redis-#{node[:redis][:version]}.tar.gz" do
  cwd "/tmp"
end

execute "make" do
  cwd "/tmp/redis-#{node[:redis][:version]}"
end

user "redis" do
  shell "/bin/zsh"
  action :create
end

directory node[:redis][:datadir] do
  owner node[:redis][:user]
  group 'users'
  mode '0755'
end

directory File.dirname(node[:redis][:log_file]) do
  action :create
  owner node[:redis][:user]
  group 'root'
  mode '0755'
end

execute "mv redis-server redis-cli #{node[:redis][:prefix]}/bin" do
  cwd "/tmp/redis-#{node[:redis][:version]}"
end

execute "chown #{node[:redis][:user]}:users redis-server redis-cli" do
  cwd "#{node[:redis][:prefix]}/bin"
end

template "/etc/init.d/redis-server" do
  source "redis.init.erb"
  owner "root"
  group "root"
  mode "0755"
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

template "/etc/monit/conf.d/redis.monitrc" do
  source "redis.monit.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "monit reload" do
  action :run
end
