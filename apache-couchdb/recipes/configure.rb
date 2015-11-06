include_recipe 'apache-couchdb::service'
include_recipe 'apache-couchdb::monitoring'

logrotate_app 'couchdb' do
  cookbook 'logrotate'
  path '/var/log/couchdb/*.log'
  frequency 'daily'
  rotate 2
end

local_dir = '/etc/couchdb/local.d'

node['apache-couchdb']['config'].each do |section, config|

  if section == 'admins'
    ini_file = "#{local_dir}/local.ini"
    config.each do |user, pw|
      unless pw.start_with?('-pbkdf2-')
        Chef::Log.error('Unencrypted passwords in node attr will lead to couch restart on each deploy!')
      end
    end
  else
    ini_file = "#{local_dir}/#{section}.ini"
  end

  template ini_file do # ~FC022
    source 'local.ini.erb'
    variables(
      :section => section,
      :config => config
    )
    notifies :restart, 'service[couchdb]', :delayed
  end
end
