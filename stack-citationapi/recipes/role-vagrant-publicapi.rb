raise 'This recipe is vagrant only' if is_aws

include_recipe 'stack-citationapi::role-publicapi'
include_recipe 'php::module-xdebug'
include_recipe 'php::module-pdo_sqlite'
package 'mysql-server-5.6'
package 'mysql-client-5.6'
include_recipe 'redis::default'
include_recipe 'nodejs'
