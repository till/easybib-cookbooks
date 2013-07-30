template "/etc/rsyslog.d/10-haproxy.conf" do
  source "10-haproxy.conf.erb"
  mode "0644"
  only_if do
    get_instance_roles().include?('loadbalancer')
  end
end

directory node["syslog"]["haproxy"]["log_dir"] do
  recursive true
  mode "0755"
  only_if do
    get_instance_roles().include?('loadbalancer')
  end
end

service "rsyslog" do
  supports :status => true, :restart => true, :reload => true
  action [ :restart ]
end
