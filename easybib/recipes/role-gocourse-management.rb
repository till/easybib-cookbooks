include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "nginx-app::server"
include_recipe "php-fpm"
include_recipe "php-phar"
include_recipe "php-intl"
include_recipe "php-suhosin"
include_recipe "composer::configure"
include_recipe "deploy::gocourse-management"
include_recipe "nginx-app::gocourse-management"
if is_aws()
  include_recipe "newrelic"
end
include_recipe "bash::configure"
