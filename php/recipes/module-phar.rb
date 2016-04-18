include_recipe 'php::dependencies-ppa'

module_config = node['php-phar']['settings']

php_ppa_package 'phar'

php_config 'phar' do
  config module_config
  notifies :reload, 'service[php-fpm]', :delayed
end
