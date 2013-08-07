# API

include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "nginx-app::server"
include_recipe "php-fpm"
include_recipe "php-phar"
include_recipe "php-suhosin"
include_recipe "php-intl"
include_recipe "unfuddle-ssl-fix::install"
include_recipe "composer::configure"
include_recipe "deploy::api"
include_recipe "nginx-app::api"

if is_aws()
  include_recipe "newrelic"
end
