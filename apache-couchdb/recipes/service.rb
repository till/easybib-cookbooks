service 'couchdb' do
  action :nothing
  provider Chef::Provider::Service::Upstart
  supports [:start, :stop, :restart]
end

template '/etc/init/couchdb.conf' do
  source 'couchdb.conf.erb'
  variables(:database_dir => node['apache-couchdb']['config']['couchdb']['database_dir'])
  notifies :restart, 'service[couchdb]', :immediately
end
