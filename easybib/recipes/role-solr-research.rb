include_recipe "easybib::role-phpapp"

include_recipe "php-pear"
include_recipe "php-gearman"

include_recipe "unfuddle-ssl-fix::install"
include_recipe "apache-solr"