Chef::Log.warn('Thi stack still uses the old stack-citationapi::role-internalapi recipe!!!')

include_recipe 'stack-citationapi::role-citation-data-api'
include_recipe 'stack-citationapi::role-sitescraper'
