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
