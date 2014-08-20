include_recipe "aptly::repo"

package "php5-easybib-opcache"

include_recipe "php-opcache::configure"
