include_recipe 'supervisor'
include_recipe 'stack-easybib::role-phpapp'

unless node['haproxy']['websocket_layers'].nil?
  if has_role?(get_instance_roles, node['haproxy']['websocket_layers'].keys.first)
    node.set['nodejs']['version'] = '4.2.6'
    include_recipe 'nodejs::install'
  end
end

include_recipe 'easybib-deploy::scholar'
