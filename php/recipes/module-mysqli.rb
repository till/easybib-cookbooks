include_recipe 'php::dependencies-ppa'

module_config = node['php-mysqli']['settings']
package_name = node['php']['ppa']['package_prefix']

package package_name do
  action :install
  notifies :reload, 'service[php-fpm]', :delayed
end

php_config 'mysqli' do
  load_priority 30
  config module_config
  config_dir node['php']['extensions']['config_dir']
  suffix node['php']['extensions']['ini_suffix']
  notifies :reload, 'service[php-fpm]', :delayed
end
