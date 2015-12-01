Chef::Log.warn('DEPRECATED: This setup is still still not using the new stack-* cookbooks!')
include_recipe 'stack-api::role-nginxphpapp'
