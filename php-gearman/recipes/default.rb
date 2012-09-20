include_recipe "apt::ppa"
include_recipe "apt::easybib"

package "php5-easybib-gearman"

include_recipe "php-fpm::service"
