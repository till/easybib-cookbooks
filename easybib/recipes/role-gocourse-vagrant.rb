service "avahi-aliases" do
  supports [:start, :stop, :restart]
  action :nothing
  provider Chef::Provider::Service::Upstart
end

Chef::Log.debug(node["gocourse"]["domain"])

template "/etc/avahi/aliases.d/gocourse" do
  source "gocourse-alias.erb"
  mode "0644"
  variables({
    :domains => node["gocourse"]["domain"]
  })
  notifies :restart, "service[avahi-aliases]"
end
