include_recipe "easybib::role-phpapp"

include_recipe "php-intl"

include_recipe "deploy::getcourse-management"
include_recipe "nginx-app::getcourse-management"
include_recipe "bash::configure"
