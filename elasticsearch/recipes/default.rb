package "openjdk-7-jre-headless"

deb_name = "elasticsearch-" + node[:elasticsearch][:version] + ".deb"
deb_url  = node[:elasticsearch][:mirror] + "/" + deb_name
deb_path = Chef::Config[:file_cache_path] + "/" + deb_name

remote_file deb_path do
  source deb_url
  not_if do
    File.exists?(deb_path)
  end
end

dpkg_package "elasticsearch" do
  source  deb_path
  version node[:elasticsearch][:version]
  action  :install
end

include_recipe "elasticsearch::service"