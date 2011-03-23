require_recipe "apt" 

case node.platform
when "ubuntu"
  membasever="1.6.5"
  architecture="x86_64"
  remote_file "/tmp/membase-server-community_#{architecture}_#{membasever}.deb" do
    #fixme: this .deb should probably be mirrored somewhere at easybib:
    source "http://c3045942.ltd.cloudfiles.rackspacecloud.com/membase-server-community_#{architecture}_#{membasever}.deb"
    mode "0644"
    backup false
    # not_if "test -f /tmp/membase-server-community_#{architecture}_#{membasever}.deb"
  end

  execute "Install membase package" do
    command "dpkg -i /tmp/membase-server-community_#{architecture}_#{membasever}.deb"
    not_if "test -f /opt/membase/#{membasever}/bin/membase"
  end
  
  execute "Cluster Init" do
    command "/opt/membase/#{membasever}/bin/cli/membase cluster-init --cluster=localhost --cluster-init-username=#{node[:membase][:adminuser]} --cluster-init-password=#{node[:membase][:adminpassword]} --cluster-init-ramsize=#{node[:membase][:clustersize]}"
  end
  
  execute "Bucket Create" do
    command "/opt/membase/#{membasever}/bin/cli/membase bucket-create --user=#{node[:membase][:adminuser]} --password=#{node[:membase][:adminpassword]}  --cluster=localhost  --bucket=#{node[:membase][:bucketname]} --bucket-type=membase --bucket-ramsize=#{node[:membase][:bucketsize]} --bucket-port=11222 --bucket-replica=1"
  end
  
end