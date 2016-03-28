include_recipe 'stack-citationapi::role-phpapp'
include_recipe 'redis::default'

include_recipe 'stack-citationapi::deploy-citationapi'
