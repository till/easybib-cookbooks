include_recipe "easybib::role-generic"

include_recipe "deploy::research"

include_recipe "apache-solr"
include_recipe "apache-solr::setup"