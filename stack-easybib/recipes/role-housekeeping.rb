include_recipe 'stack-easybib::role-phpapp'

if is_aws
  include_recipe 'easybib-deploy::easybib-housekeeping'
end
