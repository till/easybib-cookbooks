include_recipe "easybib::role-phpapp"

include_recipe "php-mysqli::configure"
include_recipe "unfuddle-ssl-fix::install"
include_recipe "php-gearman"
include_recipe "php-posix"
include_recipe "deploy::easybib"