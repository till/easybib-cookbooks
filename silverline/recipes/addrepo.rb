include_recipe "apt::ppa"

execute "librato_add_key" do
  command "curl http://apt.librato.com/packages.librato.key | apt-key add -"
end

template "/etc/apt/sources.list.d/silverline.list" do
  source "silverline.list.erb"
end

execute "apt_get_update" do
  command "apt-get update"
end
