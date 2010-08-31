remote_file "#{node[:ganglia_plugins][:plugin_dir]}/nginx_status.py" do
  source "http://github.com/csakatoku/ganglia-pymodule_nginx_status/raw/master/python_modules/nginx_status.py" do
  mode "0755"
  owner "root"
  group "root"
  create_if_missing
end

template "#{node[:ganglia_plugins][:conf_dir]}/nginx_status.pyconf" do
  source "nginx_status.pyconf.erb"
  mode "0755"
  owner "root"
  group "root"
end

service "ganglia-monitor" do
  action [ :restart ]
end