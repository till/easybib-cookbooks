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
