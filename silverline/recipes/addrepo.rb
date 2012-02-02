include_recipe "apt::ppa"

execute "apt_get_update" do
  command "apt-get update"
  action :nothing
end

execute "librato_add_key" do
  command "curl http://apt.librato.com/packages.librato.key | apt-key add -"
  action :run
end

template "/etc/apt/sources.list.d/silverline.list" do
  source "silverline.list.erb"
  notifies :run, resources(:execute => "apt_get_update"), :immediately
end
