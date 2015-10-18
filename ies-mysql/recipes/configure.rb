file node['ies-mysql']['config']['log-slow-queries'] do
  owner 'mysql'
  group 'adm'
  action :create_if_missing
  only_if do
    node['ies-mysql']['config']['log-slow-queries']
  end
end

instance = node['ies-mysql']['server-config']['instance-name']

mysql_config 'vagrant' do
  instance instance
  source 'vagrant.cnf.erb'
  variables(
    :config => node['ies-mysql']['mysqld-config']
  )
  notifies :restart, "mysql_service[#{instance}]"
end
