include_recipe 'php::dependencies-ppa'

module_config = node['php-xdebug']['settings']

php_ppa_package 'xdebug' do
  config module_config
end
