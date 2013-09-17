include_recipe "easybib::setup"
include_recipe "loggly::setup"
#include_recipe "dnsmasq"
include_recipe "nginx-app::server"
include_recipe "php-fpm"
include_recipe "php-pear"
include_recipe "php-phar"
include_recipe "php-suhosin"
include_recipe "composer::configure"
include_recipe "deploy::easybib"
include_recipe "nginx-app::sitescraper"

if is_aws()
  include_recipe "newrelic"
end
