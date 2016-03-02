include_recipe 'stack-research::role-phpapp'

include_recipe 'php::module-gearman'
include_recipe 'memcache'

include_recipe 'stack-research::deploy-research'
