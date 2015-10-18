mysql_version = node['ies-mysql'].fetch('version', '5.6')

server_config = node['ies-mysql']['server-config']

mysql_service server_config['instance-name'] do
  version mysql_version
  bind_address server_config['bind-address']
  port server_config['port']
  initial_root_password server_config['password']
  action [:create, :start]
end

mysql_client server_config['instance-name'] do
  package_version mysql_version
  action :create
end

config = node['ies-mysql']['mysqld-config']

file config['log-slow-queries'] do
  owner 'mysql'
  group 'adm'
  action :create_if_missing
  only_if do
    config['log-slow-queries']
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
