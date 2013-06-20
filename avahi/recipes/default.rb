# installs avahi-daemon
package "avahi-daemon"

template "/etc/avahi/avahi-daemon.conf" do
  source "avahi-daemon.conf.erb"
  mode   "0644"
  owner  "root"
  group  "root"
end

service "avahi-daemon" do
  supports :status => true, :restart => true, :reload => false
  action [ :restart ]
end
