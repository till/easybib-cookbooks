include_recipe 'php::dependencies-ppa'

module_config = node['php-phar']['settings']

php_ppa_package 'phar'

php_config 'phar' do
  config module_config
  load_priority node['php-phar']['load_priority']
  config_dir node['php']['extensions']['config_dir']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end
