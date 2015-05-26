remote_file "#{Chef::Config[:file_cache_path]}/vagrant.deb" do
  source node['vagrant']['url']
  checksum node['vagrant']['checksum']
  notifies :install, "dpkg_package[vagrant]", :immediately
end

dpkg_package "vagrant" do
  source "#{Chef::Config[:file_cache_path]}/vagrant.deb"
end
