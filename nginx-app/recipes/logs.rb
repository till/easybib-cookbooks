include_recipe 'rsyslogd'

error_echo_port = node['nginx-app']['error_echo_port']
acces_echo_port = node['nginx-app']['access_echo_port']

template '/etc/rsyslog.d/49-nginx.conf' do
  source 'nginx-rsyslog.erb'
  mode '0644'
  notifies :restart, 'service[rsyslog]'
end
