include_recipe 'easybib::role-phpapp'
include_recipe 'supervisor'

if is_aws
  include_recipe 'easybib-deploy::ssl-certificates'
  include_recipe 'easybib-deploy::infolit'
else
  include_recipe 'nginx-app::vagrant'
end
