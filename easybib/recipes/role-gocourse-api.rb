include_recipe "easybib::role-phpapp"

include_recipe "php-posix"
include_recipe "php-zip"
include_recipe "php-intl"
include_recipe "php-gearman"
include_recipe "php-mysqli::configure"

include_recipe "bash::configure"
include_recipe "deploy::gocourse-api"
include_recipe "nginx-app::gocourse-api"
