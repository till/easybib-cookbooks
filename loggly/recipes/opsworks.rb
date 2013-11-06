roles = get_instance_roles()

service "rsyslog" do
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

template "/etc/rsyslog.d/10-haproxy.conf" do
  source "10-haproxy.conf.erb"
  mode "0644"
  only_if do
    roles.include?('loadbalancer')
  end
  notifies :restart, "service[rsyslog]"
end

directory node["syslog"]["haproxy"]["log_dir"] do
  recursive true
  mode "0755"
  only_if do
    roles.include?('loadbalancer')
  end
end
