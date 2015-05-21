include_recipe 'easybib::setup'
include_recipe 'snooze'
include_recipe 'loggly::setup'
include_recipe 'php-fpm'
include_recipe 'php-phar'
include_recipe 'php-mysqli::configure'

node.set['composer']['environment'] = get_deploy_user
include_recipe 'composer::configure'
include_recipe 'easybib-deploy::crossref-collector'

if is_aws
  include_recipe 'newrelic' if node['easybib_deploy']['use_newrelic'] == 'yes'
end
