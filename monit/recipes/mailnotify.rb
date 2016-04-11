cookbook_file '/etc/monit/conf.d/mailnotify.monitrc' do
  source 'mailnotify.monitrc'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[monit]'
end
