Chef::Log.warn('DEPRECATED: This setup is still not using stack-* cookbooks!')
include_recipe 'stack-ops::role-smokeping'
