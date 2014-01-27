include_recipe "easybib::setup"
include_recipe "snooze"
include_recipe "loggly::setup"
include_recipe "php-fpm"
include_recipe "php-phar"
include_recipe "php-mysqli::configure"
include_recipe "composer::configure"
include_recipe "deploy::crossref-collector"

if is_aws
  include_recipe "newrelic"
end
