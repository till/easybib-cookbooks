include_recipe 'statsd::service'

base = node['librato']['statsd']['etc_dir']

directory base do
  mode  '0755'
  owner node['statsd']['user']
  group node['statsd']['group']
end

cluster_name = get_cluster_name.gsub(/\s+/, '-')

template "#{base}/localConfig.js" do
  source 'easybib-config.js.erb'
  mode   '0600'
  owner  node['statsd']['user']
  group  node['statsd']['group']
  variables(
    :statsd => node['librato']['statsd'],
    :metrics => node['librato']['metrics'],
    :cluster_name => cluster_name
  )
  notifies :start, 'service[statsd]'
end
