include_recipe 'easybib::role-phpapp'
include_recipe 'snooze'
include_recipe 'postfix'
include_recipe 'php-intl'

if is_aws
  include_recipe 'easybib-deploy::easybib-housekeeping'
end
