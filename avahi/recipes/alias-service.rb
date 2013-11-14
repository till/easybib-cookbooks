service "avahi-aliases" do
  supports [:start, :stop, :restart]
  action :nothing
  provider Chef::Provider::Service::Upstart
end
