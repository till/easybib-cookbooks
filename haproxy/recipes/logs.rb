template "/etc/rsyslog.d/10-haproxy.conf" do
  source "haproxy-logs.erb"
  mode "0644"
  notifies :restart, "service[rsyslog]"
end

directory node["syslog"]["haproxy"]["log_dir"] do
  recursive true
  mode "0755"
end
