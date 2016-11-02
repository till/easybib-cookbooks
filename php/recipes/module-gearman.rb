include_recipe 'php::dependencies-ppa'

php_ppa_package 'gearman' do
  package_prefix node['php-gearman']['package_prefix']
end
