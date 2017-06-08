include_recipe 'stack-citationapi::role-phpapp'
include_recipe 'php::module-poppler-pdf'
include_recipe 'php::module-posix'

if is_aws
  include_recipe 'stack-citationapi::deploy-citationapi'
else
  include_recipe 'redis'
  include_recipe 'ies-gearmand'
  include_recipe 'stack-citationapi::role-vagrant'
end
