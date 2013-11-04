include_recipe "php-fpm::service"

include_recipe "apt::ppa"
include_recipe "apt::easybib"

p = "php5-easybib-zlib"

package p do
  notifies :reload, "service[php-fpm]", :delayed
end