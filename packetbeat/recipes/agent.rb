require 'uri'

hostname = "#{node['opsworks']['instance']['hostname']}.#{get_normalized_cluster_name}"

filename = node['packetbeat']['agent_deb'].split('/').last
remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
  source node['packetbeat']['agent_deb']
  mode 0644
end

service 'packetbeat' do
  service_name  'packetbeat'
  supports     [:start, :stop, :restart]
end

dpkg_package 'packetbeat' do
  source  "#{Chef::Config['file_cache_path']}/#{filename}"
  action  :install
  notifies :enable, 'service[packetbeat]'
end

template '/etc/packetbeat/packetbeat.conf' do
  source 'packetbeat.conf.erb'
  mode '0644'
  variables(
    :elasticsearch => node['packetbeat']['config']['elasticsearch'],
    :protocols => node['packetbeat']['config']['protocols'],
    :procs => node['packetbeat']['config']['procs'],
    :hostname => hostname,
    :ignore_outgoing => node['packetbeat']['config']['ignore_outgoint'],
    :hide_keywords => node['packetbeat']['config']['hide_keywords']
  )
  notifies :start, 'service[packetbeat]', :immediately
end
