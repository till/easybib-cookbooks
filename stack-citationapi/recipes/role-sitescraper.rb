include_recipe 'stack-citationapi::role-phpapp'

if is_aws
  include_recipe 'stack-citationapi::deploy-citationapi'
else
  include_recipe 'stack-citationapi::deploy-vagrant'
end
