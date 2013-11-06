include_recipe "easybib::role-phpapp"

include_recipe "php-pear"
include_recipe "unfuddle-ssl-fix::install"

if is_aws()
  include_recipe "deploy::ssl-infolit"
  include_recipe "deploy::infolit"
  include_recipe "nginx-app::configure"
else
  include_recipe "nginx-app::vagrant"
end
