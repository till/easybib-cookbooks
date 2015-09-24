include_recipe 'apache-couchdb::service'

logrotate_app 'couchdb' do
  cookbook 'logrotate'
  path '/var/log/couchdb/*.log'
  frequency 'daily'
  rotate 2
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

  # write admins
  # this is a hack because 'local.ini' is always the last
  # .ini file read in the chain, so we add the admins here!
  template '/etc/couchdb/local.d/local.ini' do
    source 'local.ini.erb'
    variables(
      :section => section,
      :config => config
    )
    notifies :restart, 'service[couchdb]', :delayed
    only_if do
      section == 'admins' && !::File.exist?('/etc/couchdb/local.d/local.ini')
    end
  end
end
