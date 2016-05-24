include_recipe 'ohai'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'ies::role-phpapp'
include_recipe 'nginx-app::vagrant-silex'
include_recipe 'php::module-pdo_sqlite'
include_recipe 'nodejs'
include_recipe 'avahi'
include_recipe 'stack-service::role-rabbitmq'
include_recipe 'php::module-xdebug'

package 'wkhtmltopdf'
package 'build-essential'
package 'g++'
