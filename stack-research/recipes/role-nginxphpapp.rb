include_recipe 'stack-easybib::role-phpapp'

include_recipe 'php::module-gearman'

include_recipe 'easybib-deploy::research'

if is_aws
  include_recipe 'nginx-app::configure'
else
  include_recipe 'memcache'
  include_recipe 'nginx-app::vagrant'
end
