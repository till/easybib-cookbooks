include_recipe 'php-fpm::service'

php_ppapackage node['ppapackage-spec']['name'] do
  config node['ppapackage-spec']['config']
  package_name node['ppapackage-spec']['packagename']
end
