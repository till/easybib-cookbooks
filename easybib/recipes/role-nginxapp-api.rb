include_recipe "easybib::role-phpapp"

include_recipe "php-intl"

if is_aws
  include_recipe "easybib-deploy::api"
else
  include_recipe "nginx-app::api"
end
