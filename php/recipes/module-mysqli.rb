include_recipe 'php::dependencies-ppa'

module_config = node['php-mysqli']['settings']

php_ppa_package 'mysqli' do
  config module_config
end
