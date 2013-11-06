include_recipe "easybib::role-phpapp"

#include_recipe "dnsmasq"
include_recipe "php-pear"

include_recipe "deploy::easybib"
include_recipe "nginx-app::sitescraper"
