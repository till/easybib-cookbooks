include_recipe "easybib::role-phpapp"
include_recipe "snooze"

if is_aws
  include_recipe "deploy::easybib-housekeeping"
end
