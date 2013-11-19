template "/etc/rsyslog.d/10-haproxy.conf" do
  source "haproxy-logs.erb"
  mode "0644"
  notifies :restart, "service[rsyslog]"
end

directory node["haproxy"]["log_dir"] do
  recursive true
  mode "0755"
end

template "/etc/logrotate.d/haproxy" do
  source "logrotate.erb"
  mode "0644"
  owner "syslog"
  group "adm"
end

