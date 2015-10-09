include_recipe 'ies::role-generic'
include_recipe 'easybib-deploy::ssl-certificates'
include_recipe 'haproxy'
include_recipe 'haproxy::ctl'
