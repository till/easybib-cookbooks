include_recipe "dhcp3::service"

# this template is based on the 'default' dhclient.conf on one of our karmic instances
template "/etc/dhcp3/dhclient.conf" do
  source    "dhclient.conf.erb"
  mode      "0644"
  owner     "root"
  group     "root"
  variables :dns_server => '127.0.0.1'
  notifies  :restart, "service[networking]"
end
