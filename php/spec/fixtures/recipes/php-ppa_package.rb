include_recipe 'php-fpm::service'

php_ppa_package node['ppa_package-spec']['name'] do
  package_name node['ppa_package-spec']['packagename']
end

php_config node['ppa_package-spec']['name'] do
  config node['ppa_package-spec']['config']
  notifies :reload, 'service[php-fpm]', :delayed
end
