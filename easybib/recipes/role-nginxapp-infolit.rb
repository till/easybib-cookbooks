include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "nginx-app::server"
include_recipe "php-fpm"
include_recipe "php-pear"
include_recipe "php-phar"
include_recipe "php-suhosin"
include_recipe "unfuddle-ssl-fix::install"
include_recipe "composer::configure"

if is_aws()
  include_recipe "deploy::ssl-infolit"
  include_recipe "deploy::infolit"
  include_recipe "nginx-app::configure"
  include_recipe "newrelic"
else
  include_recipe "nginx-app::vagrant"
end
