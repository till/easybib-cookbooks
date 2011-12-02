case node.platform
when "ubuntu"
  membasever   = node[:membase][:ver]
  architecture = node[:kernel][:machine]

  remote_file "#{Chef::Config[:file_cache_path]}/moxi-server_#{architecture}_#{membasever}.deb" do
    source "#{node[:membase][:moxidl]}"
    mode "0644"
    backup false
    not_if "test -f #{Chef::Config[:file_cache_path]}/moxi-server_#{architecture}_#{membasever}.deb"
  end

  execute "Install moxi package" do
    command "dpkg -i #{Chef::Config[:file_cache_path]}/moxi-server_#{architecture}_#{membasever}.deb"
    not_if "test -f /opt/moxi/bin/moxi"
  end
  
  service "moxi-server" do
    supports :status => true, :restart => true, :start => true, :stop => true
    status_command "/etc/init.d/moxi-server status | grep 'moxi is running'"
    action :enable
  end
  
  template "/opt/moxi/etc/moxi.cfg" do
    source "moxi.cfg.erb"
    action :create
    owner "moxi"
    group "moxi"
    mode "0644"
    notifies :restart, resources(:service => "moxi-server")
  end

  # Find other membase server that match the version of membase being installed and add this server to the cluster.
  servers = search(:node, "membase_ver:#{node[:membase][:ver]} AND role:membase_cluster")
  if servers.count > 0 then
    template "/opt/moxi/etc/moxi-cluster.cfg" do
      source "moxi-cluster.cfg.erb"
      variables(
        :url => servers[0][:ipaddress]
      )
      owner "moxi"
      group "moxi"
      mode "0644"
      action :create
      notifies :restart, resources(:service => "moxi-server")
    end
  end
  
end
