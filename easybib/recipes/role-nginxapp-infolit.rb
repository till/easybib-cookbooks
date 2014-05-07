include_recipe "easybib::role-phpapp"

if is_aws
  include_recipe "easybib_deploy::ssl-infolit"
  include_recipe "easybib_deploy::infolit"
  include_recipe "nginx-app::configure"
else
  include_recipe "nginx-app::vagrant"
end
