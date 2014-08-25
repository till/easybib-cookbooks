include_recipe "easybib::role-phpapp"

include_recipe "php-posix"
include_recipe "php-zip"
include_recipe "php-intl"
include_recipe "php-gearman"
include_recipe "php-mysqli::configure"

include_recipe "snooze"
include_recipe "bash::bashrc"
include_recipe "bash::configure"
include_recipe "getcourse-deploy::api"
include_recipe "nginx-app::getcourse-api"
include_recipe "nginx-app::getcourse-ff"

unless is_aws
  include_recipe "getcourse-deploy::vagrant-gearman"
end
