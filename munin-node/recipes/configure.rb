require 'resolv'

clusterInstances = node[:scalarium][:roles]["monitoring-master"][:instances]
clusterRoles     = node[:scalarium][:roles]

if clusterRoles.include?('monitoring-master') && !clusterInstances.empty?

  logMaster = clusterInstances[node[:munin_node][:master]]
  ip_munin  = Resolv.getaddress(logMaster["private_dns_name"])

  template "/etc/munin/munin-node.conf" do
    source "munin-node.erb"
    variables({
      :ip_munin => ip_munin
    })
  end

  # this is the instance we are on
  currentInstance = node[:scalarium][:instance]

  if currentInstance[:roles].include?('nginxphpapp')
    include_recipe "munin-node::nginx"
    include_recipe "munin-node::phpfpm"
  end

  if currentInstance[:roles].include?('redis')
    include_recipe "munin-node::redis"
  end

end
