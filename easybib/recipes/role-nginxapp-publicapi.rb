include_recipe 'easybib::role-phpapp'

include_recipe 'php-gearman'
include_recipe 'php-zip'
include_recipe 'php-zlib'

include_recipe 'easybib-deploy::easybib'


if is_aws
  package 'redis-server'
  include_recipe 'nginx-app::configure'
else
  # we use our recipe instead of the default package, because
  # our recipe writes data to disk instead of memory, so it survives
  # a vagrant suspend
  include_recipe 'redis::default'
  include_recipe 'memcache'
  include_recipe 'nginx-app::vagrant'
end
