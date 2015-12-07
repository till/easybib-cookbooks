include_recipe 'php::dependencies-ppa'

module_config = node['php-phar']['settings']

php_ppa_package 'phar' do
  config module_config
end
