include_recipe "php-fpm::service"

include_recipe "apt::ppa"
include_recipe "apt::easybib"

case node[:lsb][:codename]
when 'lucid'
  p = "php5-easybib-gearman"
when 'precise'
  p = "php5-gearman"
end

package p do
  notifies :reload, resources(:service => "php-fpm"), :delayed
end
