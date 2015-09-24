service 'couchdb' do
  action :nothing
  provider Chef::Provider::Service::Upstart
  supports [:start, :stop, :restart]
end
