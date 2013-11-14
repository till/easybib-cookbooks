include_recipe "easybib::role-generic"
include_recipe "php-fpm"
include_recipe "php-phar"
include_recipe "php-suhosin"
include_recipe "composer::configure"

if is_aws()
  include_recipe "newrelic"
end
