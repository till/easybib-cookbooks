Chef::Log.warn('Using deprecated easybib::role-generic')
include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'
