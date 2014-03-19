include_recipe "easybib::role-phpapp"

if is_aws
  include_recipe "deploy::easybib-housekeeping"
end
