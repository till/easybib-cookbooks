include_recipe "easybib::role-phpapp"

include_recipe "php-intl"
include_recipe "unfuddle-ssl-fix::install"

include_recipe "deploy::api"
include_recipe "nginx-app::api"