include_recipe "avahi::alias-service"

template "/etc/avahi/aliases.d/gocourse" do
  cookbook "avahi"
  source "alias.erb"
  mode "0644"
  variables({
    :domains => node["gocourse"]["domain"]
  })
  notifies :restart, "service[avahi-aliases]"
end
