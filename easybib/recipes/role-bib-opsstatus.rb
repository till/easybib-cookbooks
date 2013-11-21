include_recipe "easybib::role-phpapp"

include_recipe "php-pear"
include_recipe "php-posix"
include_recipe "deploy::bib-opsstatus"
include_recipe "nginx-app::bib-opsstatus"
