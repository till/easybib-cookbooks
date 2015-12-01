include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'

include_recipe 'apache-solr'
include_recipe 'easybib-deploy::research-solr'
