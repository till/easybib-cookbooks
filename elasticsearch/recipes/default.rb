package "openjdk-7-jre-headless"

remote_file "#{Chef::Config[:file_cache_path]}/elasticsearch-#{node[:elasticsearch][:version]}.deb" do
  source "#{node[:elasticsearch][:mirror]}/elasticsearch-#{node[:elasticsearch][:version]}.deb"
  not_if do
    File.exists?("#{Chef::Config[:file_cache_path]}/elasticsearch-#{node[:elasticsearch][:version]}.deb")
  end
end

dpkg_package "elasticsearch" do
  source "#{Chef::Config[:file_cache_path]}/elasticsearch-#{node[:elasticsearch][:version]}.deb"
  version node[:elasticsearch][:version]
  action :install
end

include_recipe "elasticsearch::service"