include_recipe "easybib::role-phpapp"

include_recipe "php-pear"
include_recipe "php-posix"
include_recipe "deploy::bibcd"
include_recipe "nginx-app::bibcd"