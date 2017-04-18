include_recipe 'php::dependencies-ppa'

module_config = node['php-xdebug']['settings']

php_ppa_package 'xdebug'

php_config 'xdebug' do
  load_priority 50
  config module_config
  config_dir node['php']['extensions']['config_dir']
  load_priority node['php-xdebug']['load_priority']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end
