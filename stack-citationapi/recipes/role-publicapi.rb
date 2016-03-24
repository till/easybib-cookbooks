Chef::Log.warn('This stack still uses the old stack-citationapi::role-publicapi recipe!!!')

include_recipe 'stack-citationapi::role-formatting-api'
