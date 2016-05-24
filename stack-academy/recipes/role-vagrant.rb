include_recipe 'ohai'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'ies::role-phpapp'


include_recipe 'nginx-app::vagrant-silex'

easybib_envconfig 'infolit'
easybib_nginx 'infolit' do
  cookbook 'stack-academy'
  config_template 'infolit.conf.erb'
  notifies :reload, 'service[nginx]', :delayed
  notifies :restart, 'service[php-fpm]', :delayed
end

include_recipe 'php::module-pdo_sqlite'
include_recipe 'nodejs'
include_recipe 'avahi'
include_recipe 'stack-service::role-rabbitmq'
include_recipe 'php::module-xdebug'

package 'libxrender1'
package 'build-essential'
package 'g++'
