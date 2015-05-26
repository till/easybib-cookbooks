include_recipe 'easybib::role-generic'
include_recipe 'php-fpm'
include_recipe 'php-fpm::ohai'
include_recipe 'php-phar'
include_recipe 'php-suhosin'
include_recipe 'php-zlib'

node.set['composer']['environment'] = get_deploy_user if is_aws
include_recipe 'composer::configure'

include_recipe 'supervisor'

if node['easybib_deploy']['provide_pear']
  include_recipe 'php-pear'
end

if is_aws
  include_recipe 'php-opcache::configure'
  include_recipe 'qafoo-profiler' if node['easybib_deploy']['use_newrelic'] != 'yes'
  include_recipe 'php-xhprof' if node['easybib_deploy']['use_newrelic'] != 'yes'
end
