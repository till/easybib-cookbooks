include_recipe 'ies::role-generic'

if is_aws
  include_recipe 'gearmand'
else
  include_recipe 'ies-gearmand'
end
