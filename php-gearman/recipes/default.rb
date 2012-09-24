include_recipe "apt::ppa"
include_recipe "apt::easybib"

package "php5-easybib-gearman" do
  notifies :restart, resources(:service => "php-fpm"), :delayed
end

include_recipe "php-fpm::service"

service "php-fpm" do
  action :restart
end
