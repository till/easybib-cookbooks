include_recipe "apt::ppa"

execute "packages_librato_key" do
  command "curl http://apt.librato.com/packages.librato.key | apt-key add -"
  action :nothing
end

template "/etc/apt/sources.list.d/silverline.list" do
  source "silverline.list.erb"
  notifies :run, "execute[packages_librato_key]", :immediately
end

execute "apt_get_update" do
  command "apt-get update"
  action :run
end
