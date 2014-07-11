apt_package "install add-apt-repository" do
  package_name "python-software-properties"
end

execute "add libboost ppa" do
  command "add-apt-repository -y #{node["php-hhvm"]["boost"]["ppa"]}"
end

apt_repository "hhvm" do
  uri node["php-hhvm"]["apt"]["repo"]
  distribution node["lsb"]["codename"]
  components ["main"]
  key node["php-hhvm"]["apt"]["key"]
end

execute "apt-get update" do
  command "apt-get update"
end

apt_package "install hhvm" do
  package_name "hhvm"
end

include_recipe "php-hhvm::configure"
