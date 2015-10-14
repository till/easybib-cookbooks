include_recipe 'ohai'
include_recipe 'percona::server'
include_recipe 'percona::dev'
include_recipe 'easybib::role-phpapp'
include_recipe 'nginx-app::vagrant'
include_recipe 'php-pdo_sqlite'
include_recipe 'nodejs'
include_recipe 'avahi'
include_recipe 'service::role-rabbitmq'
include_recipe 'php-xdebug'

package 'build-essential'
package 'g++'

