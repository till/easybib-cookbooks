mysql_version = node['ies-mysql'].fetch('version', '5.6')

server_config = node['ies-mysql']['server-config']

mysql_service server_config['instance-name'] do
  version mysql_version
  bind_address server_config['bind-address']
  port server_config['port']
  initial_root_password server_config['password']
  provider Chef::Provider::MysqlServiceUpstart
  action [:create, :start]
end

mysql_client server_config['instance-name'] do
  version mysql_version
  action :create
end

include_recipe 'ies-mysql::client'

config = node['ies-mysql']['mysqld-config']

file config['slow_query_log_file'] do
  owner 'mysql'
  group 'mysql'
  action :create_if_missing
  only_if do
    config['slow_query_log_file']
  end
end

instance = node['ies-mysql']['server-config']['instance-name']

mysql_config 'vagrant-settings' do
  instance instance
  source 'vagrant.cnf.erb'
  variables(
    :config => config
  )
  notifies :restart, "mysql_service[#{instance}]"
end

# begin SUPER SUCKY HACKARIFIC
template '/home/vagrant/.my.cnf' do
  source 'vagrant-user.cnf.erb'
  variables(:mysql_user => node['ies-mysql']['server-config']['user'],
            :mysql_pass => node['ies-mysql']['server-config']['password'],
            :mysql_instance => node['ies-mysql']['server-config']['instance-name'])
  only_if { ::File.exist?('/vagrant') }
end
template '/root/.my.cnf' do
  source 'vagrant-user.cnf.erb'
  variables(:mysql_user => node['ies-mysql']['server-config']['user'],
            :mysql_pass => node['ies-mysql']['server-config']['password'],
            :mysql_instance => node['ies-mysql']['server-config']['instance-name'])
  only_if { ::File.exist?('/vagrant') }
end
