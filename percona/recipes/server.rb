include_recipe 'percona::repository'
include_recipe 'percona::client'

service 'mysql' do
  action :nothing
  supports [ :start, :stop, :restart ]
end

case node['percona']['version']
when '5.0'
  fail '5.0 is gone!'
when '5.1'
  package 'percona-server-server-5.1'
when '5.5'
  package 'percona-server-server-5.5'
else
  # wat?
  Chef::Log.debug("Unknown version: #{node['percona']['version']}")
end

template '/etc/mysql/conf.d/vagrant.cnf' do
  mode 0644
  source 'vagrant.cnf.erb'
  variables(
    :config => node['percona']['config']
  )
  notifies :restart, 'service[mysql]', :delayed
  not_if do
    ::EasyBib.is_aws(node)
  end
end
