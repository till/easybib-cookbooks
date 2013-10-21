# installs avahi-daemon
package "avahi-daemon"

package "avahi-autoipd" do
  action :install
  only_if do
    node["lsb"]["codename"] == 'precise'
  end
end

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
