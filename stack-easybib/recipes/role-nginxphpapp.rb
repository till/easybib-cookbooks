include_recipe 'stack-easybib::role-phpapp'
include_recipe 'php-fpm::service'
include_recipe 'php::module-gearman'

if is_aws
  include_recipe 'stack-easybib::deploy-easybib'
  include_recipe 'postfix::relay'
else
  include_recipe 'stack-easybib::deploy-easybib-vagrant'
  include_recipe 'memcache'
end
