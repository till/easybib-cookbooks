include_recipe 'ies::role-generic'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'

include_recipe 'ohai'
include_recipe 'memcache'

# fake sqs for local simulation of aws sqs
include_recipe 'fake-sqs'

include_recipe 'stack-easybib::role-phpapp'
include_recipe 'nginx-app::vagrant-silex'
include_recipe 'stack-easybib::role-nginxphpapp'
include_recipe 'stack-service::role-gearmand'
include_recipe 'stack-easybib::role-gearmanw'
include_recipe 'nodejs::npm'

# dev dependencies last
include_recipe 'php::module-pdo_sqlite'
include_recipe 'php::module-xdebug'
