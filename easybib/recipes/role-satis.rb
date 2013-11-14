include_recipe "easybib::setup"
include_recipe "loggly::setup"
include_recipe "php-fpm"
include_recipe "unfuddle-ssl-fix::install"
include_recipe "php-phar"
include_recipe "php-posix"
include_recipe "composer::configure"
include_recipe "deploy::satis"

if is_aws()
  include_recipe "newrelic"
end
