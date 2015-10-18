mysql_client node['ies-mysql']['server-config']['instance-name'] do
  version node['ies-mysql'].fetch('version', '5.6')
  action :create
end
