include_recipe "apt::ppa"

execute "apt_get_update" do
  command "apt-get update"
  action :nothing
end

key_file = "#{Chef::Config[:file_cache_path]}/packages.librato.key"

remote_file key_file do
  source "http://apt.librato.com/packages.librato.key"
end

execute "librato_add_key" do
  command "cat #{key_file} | apt-key add -"
  action :run
end

template "/etc/apt/sources.list.d/silverline.list" do
  mode   "0644"
  source "silverline.list.erb"
  notifies :run, resources(:execute => "apt_get_update"), :immediately
end
