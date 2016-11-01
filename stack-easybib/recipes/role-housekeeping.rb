include_recipe 'stack-easybib::role-phpapp'
include_recipe 'supervisor'

if is_aws
  include_recipe 'stack-easybib::deploy-easybib'
  include_recipe 'stack-easybib::deploy-housekeeping'
else
  include_recipe 'stack-easybib::deploy-easybib-vagrant'
end
