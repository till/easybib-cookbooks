include_recipe "easybib::role-generic"
include_recipe "php-fpm"
include_recipe "php-phar"
include_recipe "php-suhosin"
include_recipe "composer::configure"

if node['easybib_deploy']['provide_pear']
  include_recipe "php-pear"
end

if is_aws
  include_recipe "php-opcache::configure"
  include_recipe "newrelic"
end
