include_recipe "apt::ppa"
include_recipe "apt::easybib"

package "php5-easybib-suhosin"

include_recipe "php-suhosin::configure"
