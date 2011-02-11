require 'resolv'

package "munin-node"

service "munin-node" do
  supports :restart => true, :reload => true, :start => true, :stop => true
  action [ :enable ]
end

ip_munin = Resolv.getaddress(node[:scalarium][:roles]["monitoring-master"][:instances]["darth-vader"]["private_dns_name"])

template "/etc/munin/munin-node.conf" do
  source "munin-node.erb"
  variables({
    :ip_munin => ip_munin
  })
end

if node[:scalarium][:instance][:roles].include?('nginxphpapp')
  include_recipe "munin-node::nginx"
  include_recipe "munin-node::phpfpm"
end
