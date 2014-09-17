include_recipe 'monit::service'

template '/etc/monit/conf.d/haproxy.monitrc' do
  source 'haproxy.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'pid_file' => '/var/run/haproxy.pid',
    'app_name' => 'monit',
    'init'     => '/etc/init.d/haproxy'
  )
  notifies :restart, 'service[monit]'
end
