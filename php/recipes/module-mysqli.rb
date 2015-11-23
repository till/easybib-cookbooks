include_recipe 'php::dependencies-ppa'

module_config = node['php-mysqli']['settings']

php_ppapackage 'mysqli' do
  config module_config
end
