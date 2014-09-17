include_recipe 'monit::service'

template '/etc/monit/conf.d/gearmand.monitrc' do
  source 'gearmand.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'pid_file' => '/var/run/gearmand-easybib/gearmand-easybib.pid',
    'app_name' => 'gearmand',
    'group'    => 'gearman',
    'init'     => '/etc/init.d/gearmand-easybib'
  )
  notifies :restart, 'service[monit]'
end
