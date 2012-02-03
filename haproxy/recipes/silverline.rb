include_recipe "haproxy"

template "/etc/default/haproxy" do
  source "default.erb"
  mode "0644"
end

template "/etc/init.d/haproxy" do
  source "haproxy.init.erb"
  mode "0755"
  notifies :restart, "service[haproxy]"
end
