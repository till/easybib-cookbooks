include_recipe "easybib::role-phpapp"

include_recipe "php-intl"

include_recipe "bash::configure"
include_recipe "bash::bashrc"
include_recipe "deploy::getcourse-management"
include_recipe "nginx-app::getcourse-management"
