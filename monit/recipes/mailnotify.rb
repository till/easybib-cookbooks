template '/etc/monit/conf.d/mailnotify.monitrc' do
  source 'mailnotify.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'host'     => node['monit']['mailhost'],
    'mailuser' => node['monit']['mailuser'],
    'mailpass' => node['monit']['mailpass'],
    'mailsender' => node['monit']['mailsender'],
    'recipients' => node['monit']['notification_recipients']
  )
  notifies :restart, 'service[monit]'
  not_if { node['monit']['notification_recipients'].nil? }
end
