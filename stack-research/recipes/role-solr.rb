include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'

include_recipe 'apache-solr'
include_recipe 'stack-research::deploy-solr'
include_recipe 'monit::research-solr'
