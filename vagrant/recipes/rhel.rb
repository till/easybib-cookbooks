remote_file "#{Chef::Config[:file_cache_path]}/vagrant.rpm" do
  source node['vagrant']['url']
  checksum node['vagrant']['checksum']
  notifies :install, "rpm_package[vagrant]", :immediately
end

rpm_package "vagrant" do
  source "#{Chef::Config[:file_cache_path]}/vagrant.rpm"
end
