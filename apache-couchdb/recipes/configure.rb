service 'couchdb' do
  action :nothing
  provider Chef::Provider::Service::Upstart
  supports [:start, :stop, :restart]
end

node['apache-couchdb']['config'].each do |section, config|
  template "/etc/couchdb/local.d/#{section}.ini" do
    source 'local.ini.erb'
    variables(
      :section => section,
      :config => config
    )
    notifies :restart, 'service[couchdb]', :delayed
  end
end
