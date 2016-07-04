include_recipe 'stack-citationapi::role-phpapp'
include_recipe 'gearmand'
include_recipe 'php::module-poppler-pdf'

if is_aws
  include_recipe 'stack-citationapi::deploy-citationapi'
else
  include_recipe 'redis'
  include_recipe 'stack-citationapi::role-vagrant'
end
