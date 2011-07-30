case node.platform
when "ubuntu"
  membasever   = node[:membase][:ver]
  architecture = node[:kernel][:machine]

# Not sure this is necessary anymore, as membase 1.7.1 includes its own version of sqlite.
#  package "sqlite3"
  
  remote_file "#{Chef::Config[:file_cache_path]}/membase-server-community_#{architecture}_#{membasever}.deb" do
    source "#{node[:membase][:download]}"
    mode "0644"
    backup false
    not_if "test -f #{Chef::Config[:file_cache_path]}/membase-server-community_#{architecture}_#{membasever}.deb"
  end

  execute "Install membase package" do
    command "dpkg -i #{Chef::Config[:file_cache_path]}/membase-server-community_#{architecture}_#{membasever}.deb"
    not_if "test -f /opt/membase/bin/membase"
  end
  
  service "membase-server" do
    supports :status => true, :restart => true, :start => true, :stop => true
    status_command "/etc/init.d/membase-server status | grep 'membase is running'"
    action [:enable, :start]
  end
  
  execute "naptime" do
    # Maybe there was a race condition while membase started.  Try commenting this out if you like.
    command "sleep 3"
  end

  # Find other membase server that match the version of membase being installed and add this server to the cluster.
  servers = search(:node, %Q{membase_ver:"#{node[:membase][:ver]}" AND role:membase_cluster})
  if servers.count > 0 then
    Chef::Log.info "Found #{servers.first} (#{servers[0][:ipaddress]}).  Will add this server to its cluster."
    execute "Server Add" do
      command "/opt/membase/bin/membase rebalance --cluster=#{servers[0][:ipaddress]}:8091 --user=#{node[:membase][:adminuser]} --password=#{node[:membase][:adminpassword]} --server-add=#{node[:ipaddress]}:8091 --server-add-username=#{servers[0][:membase][:adminuser]} --server-add-password=#{servers[0][:membase][:adminpassword]}"
      not_if "/opt/membase/bin/membase server-list --cluster=#{servers[0][:ipaddress]}:8091 --user=#{node[:membase][:adminuser]} --password=#{node[:membase][:adminpassword]} | grep #{node[:ipaddress]}"
    end
  else
  # There are no other nodes, so initialize a new cluster.
    Chef::Log.info "No servers found.  Will initialize a new cluster."
    execute "Cluster Init" do
      command "/opt/membase/bin/membase cluster-init --cluster=localhost:8091 --cluster-init-username=#{node[:membase][:adminuser]} --cluster-init-password=#{node[:membase][:adminpassword]} --cluster-init-ramsize=#{node[:membase][:clustersize]}"
    end
  end
  
  execute "Bucket Create" do
    command "/opt/membase/bin/membase bucket-create --user=#{node[:membase][:adminuser]} --password=#{node[:membase][:adminpassword]}  --cluster=localhost  --bucket=#{node[:membase][:bucketname]} --bucket-type=membase --bucket-ramsize=#{node[:membase][:bucketsize]} --bucket-port=11222 --bucket-replica=1"
    not_if "/opt/membase/bin/membase bucket-list --cluster=#{servers[0][:ipaddress]}:8091 --user=#{node[:membase][:adminuser]} --password=#{node[:membase][:adminpassword]} | grep #{node[:membase][:bucketname]}"
  end

end
