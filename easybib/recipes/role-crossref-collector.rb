include_recipe 'ies::role-generic'
include_recipe 'snooze'
include_recipe 'php-fpm'
include_recipe 'php::module-phar'
include_recipe 'php::module-mysqli'

node.set['composer']['environment'] = get_deploy_user
include_recipe 'composer::configure'

include_recipe 'easybib-deploy::crossref-collector'
