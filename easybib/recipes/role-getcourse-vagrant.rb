include_recipe "avahi::alias-service"

template "/etc/avahi/aliases.d/getcourse" do
  cookbook "avahi"
  source "alias.erb"
  mode "0644"
  variables({
    :domains => node["getcourse"]["domain"]
  })
  notifies :restart, "service[avahi-aliases]"
end
