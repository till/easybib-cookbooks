require 'resolv'

remote_file "#{node[:ganglia_plugins][:plugin_dir]}/redis.py" do
  source "http://github.com/ganglia/gmond_python_modules/raw/master/redis/redis.py" do
  mode "0755"
  owner "root"
  group "root"
  create_if_missing
end

if node[:scalarium] && node[:scalarium][:roles][:redis][:instances].any?
    redis_instance = node[:scalarium][:roles][:redis][:instances].first
    redis_host     = Resolv.getaddress(redis_instance[:private_dns_name])
    redis_port     = node[:ganglia_plugins][:redis][:port]
else
    redis_host = node[:ganglia_plugins][:redis][:host]
    redis_port = node[:ganglia_plugins][:redis][:port]
end

template "#{node[:ganglia_plugins][:conf_dir]}/redis.pyconf" do
  source "redis.pyconf.erb"
  mode "0755"
  owner "root"
  group "root"
  variables :host => redis_host, :port => redis_port
end

service "ganglia-monitor" do
  action [ :restart ]
end