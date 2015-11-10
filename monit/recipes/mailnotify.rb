file '/etc/monit/conf.d/mailnotify.monitrc' do
  content 'set alert root@localhost but not on { pid ppid nonexist instance timestamp }'
  mode '0644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[monit]'
end
