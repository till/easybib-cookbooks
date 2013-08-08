include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "php-fpm"
include_recipe "php-pear"
include_recipe "php-phar"
include_recipe "php-posix"
include_recipe "composer::configure"
include_recipe "deploy::bibcd"
include_recipe "nginx-app::server"
include_recipe "nginx-app::bibcd"

if is_aws()
  include_recipe "newrelic"
end
