include_recipe 'monit::service'

gearman_name = node.fetch('gearmand', {}).fetch('name', 'gearman')
gearman_group = node.fetch('gearmand', {}).fetch('group', 'gearman')

template '/etc/monit/conf.d/gearmand.monitrc' do
  source 'gearmand.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'pid_file' => "/var/run/#{gearman_name}/manager.pid",
    'app_name' => gearman_name,
    'group'    => gearman_group,
    'init'     => '/etc/init.d/gearman-job-server'
  )
  notifies :restart, 'service[monit]'
end
