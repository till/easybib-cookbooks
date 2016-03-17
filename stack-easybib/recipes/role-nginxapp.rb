include_recipe 'stack-easybib::role-phpapp'
include_recipe 'php-fpm::service'
include_recipe 'php::module-gearman'
include_recipe 'stack-easybib::deploy-easybib'

if is_aws
  include_recipe 'postfix::relay'
else
  include_recipe 'memcache'
end
