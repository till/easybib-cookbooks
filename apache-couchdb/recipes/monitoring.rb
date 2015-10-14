Chef::Resource.send(:include, EasyBib)

bin_path = '/usr/local/bin/check_couchdb'

# this is an assumption for what is to follow!
monitoring_user = 'monitoring'

unless node['apache-couchdb']['config'].fetch('admins', {})[monitoring_user].nil?
  monitoring_pass = node['apache-couchdb']['config']['admins'][monitoring_user]
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
