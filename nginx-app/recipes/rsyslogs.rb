include_recipe 'rsyslogd'

template '/etc/rsyslog.d/45-nginx.conf' do
  source 'nginx-rsyslog.erb'
  mode '0644'
  notifies :restart, 'service[rsyslog]'
end
