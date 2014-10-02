require 'uri'

hostname = "#{node['opsworks']['instance']['hostname']}.#{get_normalized_cluster_name}"

filename = node['packetbeat']['agent_deb'].split('/').last
remote_file "#{Chef::Config['file_cache_path']}/#{filename}" do
  source node['packetbeat']['agent_deb']
  mode 0644
end

apt_package 'packetbeat' do
  action :install
  source "#{Chef::Config['file_cache_path']}/#{filename}"
end

service 'packetbeat' do
  service_name  'packetbeat'
  supports     [:start, :stop, :restart]
end

template '/etc/packetbeat.conf' do
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
  notifies :restart, 'service[packetbeat]', :immediately
end
