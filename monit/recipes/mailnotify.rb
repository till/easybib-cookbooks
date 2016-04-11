# The default (no configuration) is to pipe
# all alerts to root@localhost. That gets
# forwarded using postfix.
config_file = '/etc/monit/conf.d/mailnotify.monitrc'

config = node['monit']

cookbook_file config_file do
  source 'mailnotify.monitrc'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[monit]'
  only_if do
    config['mailuser'].nil? && config['mailpass'].nil?
  end
end

template config_file do
  source 'mailnotify.monit.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
    :host => config['mailhost'],
    :pass => config['mailpass'],
    :port => config['mailport'],
    :recipients => config['notification_recipients'],
    :sender => config['mailsender'],
    :user => config['mailuser']
  )
  notifies :restart, 'service[monit]'
  not_if do
    config['mailuser'].nil? && config['mailpass'].nil?
  end
end
