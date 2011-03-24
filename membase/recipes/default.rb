require_recipe "apt" 

case node.platform
when "ubuntu"
  membasever   = node[:membase][:ver]
  architecture = node[:membase][:arch]
  
#  execute "fh is debugging" do
#    command "cp /var/cache/apt/archives/membase-server-community_#{architecture}_#{membasever}.deb /tmp"
#  end
  
  remote_file "/tmp/membase-server-community_#{architecture}_#{membasever}.deb" do
    source "#{node[:membase][:download]}"
    mode "0644"
    backup false
    not_if "test -f /tmp/membase-server-community_#{architecture}_#{membasever}.deb"
  end

  execute "Install membase package" do
    command "dpkg -i /tmp/membase-server-community_#{architecture}_#{membasever}.deb"
    not_if "test -f /opt/membase/#{membasever}/bin/membase"
  end
  
  service "membase-server" do
    supports :status => true, :restart => true, :start => true, :stop => true
    status_command "/etc/init.d/membase-server status | grep 'membase is running'"
    action :restart
  end
  
  execute "membase-server init script rocks and is totally awesome, so lets sit here and watch it a litte bit longer" do
    #stupid piece of .. - the membase-script exists too early, while membase not fully running
    #so a cluster init directly as next step would lead to a connection refused error
    #lovin' it.
    command "sleep 5"
  end
  
  execute "Cluster Init" do
    command "/opt/membase/#{membasever}/bin/cli/membase cluster-init --cluster=localhost --cluster-init-username=#{node[:membase][:adminuser]} --cluster-init-password=#{node[:membase][:adminpassword]} --cluster-init-ramsize=#{node[:membase][:clustersize]}"
  end
  
  execute "Bucket Create" do
    command "/opt/membase/#{membasever}/bin/cli/membase bucket-create --user=#{node[:membase][:adminuser]} --password=#{node[:membase][:adminpassword]}  --cluster=localhost  --bucket=#{node[:membase][:bucketname]} --bucket-type=membase --bucket-ramsize=#{node[:membase][:bucketsize]} --bucket-port=11222 --bucket-replica=1"
  end
  
end
