include_recipe 'php::dependencies-ppa'

module_config = node['php-xdebug']['settings']

php_ppa_package 'xdebug'

php_config 'xdebug' do
  config module_config
  notifies :reload, 'service[php-fpm]', :delayed
end
