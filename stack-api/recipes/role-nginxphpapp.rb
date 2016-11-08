include_recipe 'ies::role-phpapp'
include_recipe 'php::module-soap'
include_recipe 'php::module-tidy'

if is_aws
  include_recipe 'stack-api::deploy-silex'
else
  include_recipe 'nginx-app::vagrant-silex'
end
