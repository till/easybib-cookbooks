include_recipe 'php::dependencies-ppa'

module_config = node['php-opcache']['settings']

php_ppa_package 'opcache'

php_config 'opcache' do
  config module_config
  config_dir node['php']['extensions']['config_dir']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end

file 'create opcache error_log' do
  path node['php-opcache']['settings']['error_log']
  mode 0755
  owner node['php-fpm']['user']
  group node['php-fpm']['group']
  notifies :reload, 'service[php-fpm]', :delayed
  not_if { node['php-opcache']['settings']['error_log'].nil? }
end
