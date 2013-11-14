include_recipe "easybib::role-phpapp"

include_recipe "php-intl"

include_recipe "deploy::gocourse-management"
include_recipe "nginx-app::gocourse-management"
include_recipe "bash::configure"
