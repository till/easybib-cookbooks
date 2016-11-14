include_recipe 'stack-fruitkid::role-phpapp'

include_recipe 'php::module-gearman'

include_recipe 'stack-fruitkid::deploy-easybib'

if is_aws
  include_recipe 'nginx-app::configure'
  include_recipe 'postfix::relay'
else
  include_recipe 'memcache'
  include_recipe 'nginx-app::vagrant'
end
