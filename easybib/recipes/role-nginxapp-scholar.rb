include_recipe 'easybib::role-phpapp'

if is_aws
  include_recipe 'easybib-deploy::silex'
else
  include_recipe 'php-pdo_sqlite'
  include_recipe 'nginx-app::vagrant-silex'
end
