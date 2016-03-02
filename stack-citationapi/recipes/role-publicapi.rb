include_recipe 'stack-easybib::role-phpapp'

include_recipe 'php::module-gearman'
include_recipe 'php::module-zip'
include_recipe 'php::module-zlib'

include_recipe 'easybib-deploy::easybib'

include_recipe 'redis::default'

if is_aws
  include_recipe 'easybib-deploy::citation-api'
else
  include_recipe 'memcache'
  include_recipe 'nginx-app::vagrant'
end
