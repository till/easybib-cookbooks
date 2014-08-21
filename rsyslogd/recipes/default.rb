service "rsyslog" do
  provider Chef::Provider::Service::Debian
  supports :status => true, :restart => true, :reload => true
  action [ :nothing ]
end

cookbook_file "/etc/rsyslog.d/10-debug-helper.conf" do
  source "debug-helper.conf"
  mode 0644
end

include_recipe "rsyslogd::mute-cron"
