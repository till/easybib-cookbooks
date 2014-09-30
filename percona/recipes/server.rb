include_recipe 'percona::repository'
include_recipe 'percona::client'

service 'mysql' do
  action :nothing
  supports [:start, :stop, :restart]
end

case node['percona']['version']
when '5.1'
  package 'percona-server-server-5.1'
when '5.5'
  package 'percona-server-server-5.5'
else
  fail "Unknown version: #{node['percona']['version']}"
end

file node['percona']['config']['log-slow-queries'] do
  owner 'mysql'
  group 'adm'
  action :create_if_missing
  only_if do
    node['percona']['config']['log-slow-queries']
  end
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
