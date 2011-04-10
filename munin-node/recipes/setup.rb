require 'resolv'

package "munin-node"
include_recipe "munin-node::service"

clusterInstances = node[:scalarium][:roles]["monitoring-master"][:instances]
clusterRoles     = node[:scalarium][:roles]

if clusterRoles.include?('monitoring-master') && !clusterInstances.empty?

  # FIXME: assuming one instance called 'darth-vader'
  logMaster = clusterInstances["darth-vader"]
  ip_munin  = Resolv.getaddress(logMaster["private_dns_name"])

  template "/etc/munin/munin-node.conf" do
    source "munin-node.erb"
    variables({
      :ip_munin => ip_munin
    })
  end

  if clusterRoles.include?('nginxphpapp')
    include_recipe "munin-node::nginx"
    include_recipe "munin-node::phpfpm"
  end

  if clusterRoles.include?('redis')
    include_recipe "munin-node::redis"
  end

end
