include_recipe 'monit::service'

template '/etc/monit/conf.d/php-fpm.monitrc' do
  source 'php-fpm.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'pid_file' => "#{node['php-fpm']['prefix']}/var/run/php-fpm.pid",
    'app_name' => 'php-fpm',
    'init'     => '/etc/init.d/php-fpm'
  )
  notifies :restart, 'service[monit]'
end
