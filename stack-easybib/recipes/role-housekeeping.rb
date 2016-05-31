include_recipe 'stack-easybib::role-phpapp'

if is_aws
  include_recipe 'stack-easybib::deploy-easybib'
  include_recipe 'easybib-deploy::easybib-housekeeping'
else
  include_recipe 'stack-easybib::deploy-easybib-vagrant'
end
