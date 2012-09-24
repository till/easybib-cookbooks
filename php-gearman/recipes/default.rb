include_recipe "apt::ppa"
include_recipe "apt::easybib"
include_recipe "php-fpm::service"

package "php5-easybib-gearman" do
  notifies :reload, resources(:service => "php-fpm"), :delayed
end
