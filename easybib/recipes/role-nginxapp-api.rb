include_recipe 'easybib::role-phpapp'

include_recipe 'php-intl'

if is_aws
  include_recipe 'easybib-deploy::silex'
else
  include_recipe 'nginx-app::vagrant-silex'
end
