include_recipe "easybib::role-phpapp"

include_recipe "php-posix"
if is_aws
  include_recipe "easybib_deploy::qa"
else
  include_recipe "nginx-app::qa"
end
