include_recipe 'php::dependencies-ppa'

module_config = node['php-opcache']['settings']

php_ppa_package 'opcache' do
  config module_config
end

file 'create opcache error_log' do
  path node['php-opcache']['settings']['error_log']
  mode 0755
  owner node['php-fpm']['user']
  group node['php-fpm']['group']
  notifies :reload, 'service[php-fpm]', :delayed
  not_if { node['php-opcache']['settings']['error_log'].nil? }
end
