template "/etc/dnsmasq.d/local.conf" do
  mode   "0644"
  source "local.erb"
  variables(
    :dnsmasq => node[:dnsmasq]
  )
end
