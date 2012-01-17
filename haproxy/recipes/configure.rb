template "/etc/default/haproxy" do
  source "default.erb"
  mode "0644"
  notifies :restart, "service[haproxy]"
end
