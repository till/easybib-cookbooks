include_recipe 'ies::setup'
include_recipe 'php-fpm'
include_recipe 'php-phar'
include_recipe 'php-posix'

node.set['composer']['environment'] = get_deploy_user
include_recipe 'composer::configure'

include_recipe 'nginx-app::configure'
include_recipe 'easybib-deploy::satis'
