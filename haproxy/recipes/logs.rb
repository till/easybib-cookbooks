if node.fetch('lsb', {}).fetch('codename', {}) == 'precise' || node.fetch('lsb', {}).fetch('codename', {}) == 'trusty'
  include_recipe 'rsyslogd'

  template '/etc/rsyslog.d/10-haproxy.conf' do
    only_if { node['lsb']['codename'] == 'precise' }
    source 'haproxy-logs.erb'
    mode '0644'
    notifies :restart, 'service[rsyslog]'
  end

  template '/etc/rsyslog.d/49-haproxy.conf' do
    only_if { node['lsb']['codename'] == 'trusty' }
    source 'haproxy-logs-trusty.erb'
    mode '0644'
    notifies :restart, 'service[rsyslog]'
  end

  directory node['haproxy']['log_dir'] do
    recursive true
    mode '0755'
  end

  template '/etc/logrotate.d/haproxy' do
    source 'logrotate.erb'
    mode '0644'
    owner 'syslog'
    group 'adm'
  end
end
