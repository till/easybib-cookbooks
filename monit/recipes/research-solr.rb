include_recipe 'monit::service'

template '/etc/monit/conf.d/apache-solr.monitrc' do
  source 'apache-solr.monitrc.erb'
  mode   '0644'
  owner  'root'
  group  'root'
  notifies :restart, 'service[monit]'
end
