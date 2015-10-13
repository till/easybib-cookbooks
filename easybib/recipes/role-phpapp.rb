include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'
include_recipe 'php-fpm'
include_recipe 'php-fpm::ohai'
include_recipe 'php-phar'
include_recipe 'php-zlib'
include_recipe 'php-intl'

node.set['composer']['environment'] = get_deploy_user if is_aws
include_recipe 'composer::configure'

if node['easybib_deploy']['provide_pear']
  include_recipe 'php-pear'
end

include_recipe 'tideways'

include_recipe 'php-opcache::configure'
