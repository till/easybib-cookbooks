Chef::Resource.send(:include, EasyBib)

bin_path = '/usr/local/bin/check_couchdb'

unless node['apache-couchdb']['monitoring']['user'].empty?
  monitoring_user = node['apache-couchdb']['monitoring']['user']
  monitoring_pass = node['apache-couchdb']['monitoring']['pass']
  credentials = "#{monitoring_user}:#{monitoring_pass}"

  template bin_path do
    source 'check_couchdb.erb'
    mode '0755'
    owner 'root'
    group 'root'
    variables(
      :credentials => credentials
    )
  end

  cron_d 'couchdb_replication' do
    command "#{bin_path} | logger"
  end
end
