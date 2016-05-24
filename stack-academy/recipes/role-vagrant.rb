include_recipe 'ohai'
include_recipe 'ies-mysql'
include_recipe 'ies-mysql::dev'
include_recipe 'ies::role-phpapp'

node['vagrant']['applications'].each do |app_name, app_data|
  easybib_envconfig app_name do
    stackname 'easybib'
  end

  app_dir = app_data['doc_root_location']

  easybib_nginx app_name do
    cookbook 'stack-academy'
    config_template 'infolit.conf.erb'
    notifies :reload, 'service[nginx]', :delayed
    notifies :restart, 'service[php-fpm]', :delayed
  end

  easybib_supervisor "#{app_name}_supervisor" do
    supervisor_file "#{app_dir}/deploy/supervisor.json"
    app_dir app_dir
    app app_name
    user node['php-fpm']['user']
    ignore_failure true
  end
end

include_recipe 'php::module-pdo_sqlite'
include_recipe 'nodejs'
include_recipe 'avahi'
include_recipe 'stack-service::role-rabbitmq'
include_recipe 'php::module-xdebug'

package 'libxrender1'
package 'build-essential'
package 'g++'
