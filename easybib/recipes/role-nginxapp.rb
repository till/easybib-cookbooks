# EasyBib

include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "nginx-app::server"
include_recipe "php-fpm"
include_recipe "php-pear"
include_recipe "php-phar"
include_recipe "php-suhosin"
include_recipe "php-gearman"
include_recipe "unfuddle-ssl-fix::install"
include_recipe "composer::configure"
include_recipe "deploy::easybib"

if is_aws()
  include_recipe "nginx-app::configure"
else
  include_recipe "memcache"
  include_recipe "nginx-app::vagrant"
end

if is_aws()
  include_recipe "newrelic"
end
