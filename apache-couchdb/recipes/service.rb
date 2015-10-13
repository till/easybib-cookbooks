template '/etc/init/couchdb.conf' do
  source 'couchdb.conf.erb'
  variables(:database_dir => node['apache-couchdb']['config']['couchdb']['database_dir'])
end

service 'couchdb' do
  action :nothing
  provider Chef::Provider::Service::Upstart
  supports [:start, :stop, :restart]
end
