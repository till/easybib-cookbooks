service 'rsyslog' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action [:nothing]
end

cookbook_file '/etc/rsyslog.d/10-debug-helper.conf' do
  source 'debug-helper.conf'
  mode 0644
end

cookbook_file '/etc/rsyslog.d/01-fix-timestamp.conf' do
  source '01-fix-timestamp.conf'
  mode 0644
end

include_recipe 'rsyslogd::mute-cron'
