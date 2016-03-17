include_recipe 'stack-easybib::role-phpapp'

include_recipe 'php::module-gearman'
include_recipe 'php::module-zip'
include_recipe 'php::module-zlib'

include_recipe 'stack-easybib::deploy-easybib'
include_recipe 'stack-easybib::deploy-gearman-worker'
include_recipe 'redis::default'

if is_aws
  include_recipe 'nginx-app::configure'
else
  include_recipe 'memcache'
  include_recipe 'nginx-app::vagrant'
end
