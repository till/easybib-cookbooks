include_recipe 'php::dependencies-ppa'

module_config = node['php-mysqli']['settings']
package_name = node['php']['ppa']['package_prefix']

package package_name do
  action :install
  notifies :reload, 'service[php-fpm]', :delayed
end

php_config 'mysqli' do
  config module_config
  notifies :reload, 'service[php-fpm]', :delayed
end
