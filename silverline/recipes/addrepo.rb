include_recipe "apt::ppa"

execute "import-silverline-key" do
  command "curl http://apt.librato.com/packages.librato.key | apt-key add -"
  action :nothing
end

template "/etc/apt/sources.list.d/silverline.list" do
  source "silverline.list.erb"
  notifies :run, "execute[import-silverline-key]", :immediately
end
