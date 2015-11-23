include_recipe 'php-fpm::service'

php_ppa_package node['ppa_package-spec']['name'] do
  config node['ppa_package-spec']['config']
  package_name node['ppa_package-spec']['packagename']
end
