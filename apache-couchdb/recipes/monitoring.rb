Chef::Resource.send(:include, EasyBib)
bin_path = '/usr/local/bin/check_couchdb'

template bin_path do
  source 'check_couchdb'
  mode '0755'
  owner 'root'
  group 'root'
end

credentials = node['apache-couchdb']['config']['admins']['monitoring']
cron_d 'couchdb_replication' do
  command "#{bin_path} -a '#{credentials}'"
end
