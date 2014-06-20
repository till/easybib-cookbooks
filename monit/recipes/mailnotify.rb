# installs the monitrc for our backup process
include_recipe "monit::service"

template "/etc/monit/conf.d/mailnotify.monitrc" do
  source "mailnotify.monit.erb"
  mode   "0644"
  owner  "root"
  group  "root"
  variables(
    'host'     => node['monit']['mailhost'],
    'mailuser' => node['monit']['mailuser'],
    'mailpass' => node['monit']['mailpass'],
    'recipients' => node['monit']['notification_recipients']
  )
  notifies :restart, "service[monit]"
  only_if !node['monit']['notification_recipients'].nil?
end
