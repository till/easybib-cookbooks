include_recipe 'php::dependencies-ppa'

package "#{node['php']['ppa']['package_prefix']}-gearman" do
  action :install
  notifies :reload, 'service[php-fpm]', :delayed
end
