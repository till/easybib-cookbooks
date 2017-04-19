include_recipe 'stack-citationapi::role-phpapp'
include_recipe 'php::module-poppler-pdf'
include_recipe 'gearmand'

if is_aws
  include_recipe 'stack-citationapi::deploy-citationapi'
else
  include_recipe 'stack-citationapi::deploy-vagrant'
end
