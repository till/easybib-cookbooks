if node['papertrail']['remote_port'].nil?
  include_recipe 'loggly::setup'
else
  Chef::Log.info("Setting up papertrail: #{node['papertrail']['remote_host']}:#{node['papertrail']['remote_port']}")
  node.set['papertrail']['hostname_name'] = get_record_name
  include_recipe 'papertrail'
end
