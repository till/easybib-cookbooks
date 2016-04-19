include_recipe 'php::dependencies-ppa'

module_config = node['php-phar']['settings']

php_ppa_package 'phar'

php_config 'phar' do
  load_priority 20
  config module_config
  config_dir node['php']['extensions']['config_dir']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end
