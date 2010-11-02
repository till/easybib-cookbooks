template "/etc/rsyslog.d/10-loggly.conf" do
  source "10-loggly.conf.erb"
  mode "0644"
end

service "rsyslog" do
  supports :status => true, :restart => true, :reload => true
  action [ :restart ]
end

template "/etc/init.d/loggly" do
  source "loggly.sh.erb"
  mode "0755"
end

service "loggly" do
  supports :start => true, :stop => true
  action [ :enable, :start ]
end
