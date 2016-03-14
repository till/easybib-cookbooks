include_recipe 'ies::role-generic'
include_recipe 'nginx-app::server'
include_recipe 'php-fpm'
include_recipe 'php-fpm::ohai'
include_recipe 'php-fpm::service'
include_recipe 'php::module-phar'
include_recipe 'php::module-zlib'
include_recipe 'php::module-intl'

node.set['composer']['environment'] = get_deploy_user if is_aws
include_recipe 'composer::configure'

include_recipe 'tideways'

include_recipe 'php::module-opcache'
