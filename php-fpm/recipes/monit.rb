include_recipe 'monit::service'

init_command = if node['php']['ppa']['package_prefix'].include?('easybib')
                 '/etc/init.d/php-fpm'
               else
                 "service #{node['php']['ppa']['package_prefix']}-fpm restart"
               end

template '/etc/monit/conf.d/php-fpm.monitrc' do
  source 'php-fpm.monit.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  variables(
    'pid_file' => node['php-fpm']['pid'],
    'app_name' => 'php-fpm',
    'init'     => init_command
  )
  notifies :restart, 'service[monit]'
end
