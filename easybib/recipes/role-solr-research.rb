include_recipe "easybib::role-phpapp"

include_recipe "deploy::research"

include_recipe "apache-solr"
#include_recipe "apache-solr::setup"