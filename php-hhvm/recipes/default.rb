apt_package "install add-apt-repository" do
  package_name "python-software-properties"
end

execute "add libboost ppa" do
  command "add-apt-repository -y ppa:mapnik/boost"
end

remote_file "#{Chef::Config[:file_cache_path]}/hhvm.gpg.key" do
  source "http://dl.hhvm.com/conf/hhvm.gpg.key"
end

execute "add hhvm repo key" do
  command "apt-key add #{Chef::Config[:file_cache_path]}/hhvm.gpg.key"
end

execute "discover apt-repository" do
  command "echo deb #{node["php-hhvm"]["apt"]["repo"]} #{node["lsb"]["codename"]} main > #{node["php-hhvm"]["apt"]["file"]}"
  creates node["php-hhvm"]["apt"]["file"]
end

execute "update_hhvm_apt" do
  command "apt-get update -y"
end

apt_package "install hhvm" do
  package_name "hhvm"
end

include_recipe "php-hhvm::configure"
