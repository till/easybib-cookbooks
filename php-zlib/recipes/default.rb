include_recipe "php-fpm::service"

include_recipe "aptly::repo"

p = "php5-easybib-zlib"

package p do
  notifies :reload, "service[php-fpm]", :delayed
end
