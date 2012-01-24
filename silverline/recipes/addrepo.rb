include_recipe "apt::ppa"

execute "packages_librato_key" do
  command "curl http://apt.librato.com/packages.librato.key | apt-key add - && apt-get update"
  action :nothing
end

template "/etc/apt/sources.list.d/silverline.list" do
  source "silverline.list.erb"
  notifies :run, "execute[packages_librato_key]", :immediately
end
