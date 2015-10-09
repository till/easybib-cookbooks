include_recipe 'hhvm-fcgi'
include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'

if is_aws
  include_recipe 'easybib-deploy::hhvm'
else
  include_recipe 'nginx-app::hhvm'
end
