service 'couchdb' do
  action :nothing
  provider Chef::Provider::Service::Upstart
  supports [:start, :stop, :restart]
end

config = node['apache-couchdb']['config']['couchdb']

directory 'create_database_dir' do
  path config['database_dir']
  owner 'couchdb'
  group 'couchdb'
  mode 0750
  recursive true
  action :nothing
  notifies :create, 'directory[create_view_index_dir]', :immediately
end

directory 'create_view_index_dir' do
  path config['view_index_dir']
  owner 'couchdb'
  group 'couchdb'
  mode 0750
  recursive true
  action :nothing
  notifies :restart, 'service[couchdb]'
end

template '/etc/init/couchdb.override' do
  source 'couchdb.conf.erb'
  variables(:database_dir => config['database_dir'])
  notifies :create, 'directory[create_database_dir]', :immediately
end
