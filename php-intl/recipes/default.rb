include_recipe "php-fpm::service"

include_recipe "apt::ppa"
include_recipe "apt::easybib"

p = "php5-easybib-intl"

package p do
  notifies :reload, resources(:service => "php-fpm"), :delayed
end
