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
    not_if do
      section == 'admins'
    end
  end

  # write admins initial
  template "/etc/couchdb/local.d/#{section}.ini" do
    source 'local.ini.erb'
    variables(
      :section => section,
      :config => config
    )
    only_if do
      section == 'admins' && !::File.exist?('/etc/couchdb/local.d/admins.ini')
    end
  end
end
