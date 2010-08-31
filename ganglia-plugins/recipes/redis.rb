remote_file "#{node[:ganglia_plugins][:plugin_dir]}/redis.py" do
  source "http://github.com/ganglia/gmond_python_modules/raw/master/redis/redis.py" do
  mode "0755"
  owner "root"
  group "root"
  create_if_missing
end

template "#{node[:ganglia_plugins][:conf_dir]}/redis.pyconf" do
  source "redis.pyconf.erb"
  mode "0755"
  owner "root"
  group "root"
end

service "ganglia-monitor" do
  action [ :restart ]
end