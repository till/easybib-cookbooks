fail 'This recipe is vagrant only' if is_aws

include_recipe 'stack-citationapi::role-publicapi'
include_recipe 'php::module-xdebug'
include_recipe 'php::module-pdo_sqlite'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'redis::default'
include_recipe 'nodejs'
