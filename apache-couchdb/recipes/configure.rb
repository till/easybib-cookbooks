include_recipe 'apache-couchdb::service'

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
  else
    ini_file = "#{local_dir}/#{section.ini}"
  end

  template ini_file do # ~FC022
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
  template ini_file do # ~FC022
    source 'local.ini.erb'
    variables(
      :section => section,
      :config => config
    )
    notifies :restart, 'service[couchdb]', :delayed
    only_if do
      section == 'admins' && !::File.exist?(ini_file)
    end
  end
end
