package "munin-node"

include_recipe "munin-node::service"

if node[:scalarium]
  include_recipe "munin-node::configure"
end
