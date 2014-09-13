include_recipe "tsung::dependencies"

tsungver = node["tsung"]["version"]
pkgrev = node["tsung"]["pkgrev"]

remote_file "#{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb" do
  source "http://tsung.erlang-projects.org/dist/ubuntu/tsung_#{tsungver}-#{pkgrev}_all.deb"
  mode "0644"
  backup false
  not_if "test -f #{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb"
end

# dpkg_package "#{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb"

execute "Install tsung package" do
  command "dpkg -i #{Chef::Config[:file_cache_path]}/tsung_#{tsungver}-#{pkgrev}_all.deb"
  not_if "test -f /usr/bin/tsung"
end

home_dir = "/home/ubuntu"

directory "#{home_dir}/.tsung/log" do
  owner "ubuntu"
  group "ubuntu"
  mode "0755"
  action :create
  recursive true
end

template "#{home_dir}/.tsung/tsung.xml" do
  source "tsung.xml.erb"
  owner "ubuntu"
  group "ubuntu"
end

remote_file "#{home_dir}/.tsung/listids.csv" do
  source "listids.csv"
  mode "0644"
  owner "ubuntu"
  group "ubuntu"
  action :create
end

# put rules in ~/.tsung/tsung.xml
# start with tsung start
