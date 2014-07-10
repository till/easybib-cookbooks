apt_repository "liboost" do
  uri node["php-hhvm"]["apt"]["ppa"]
  distribution node["lsb"]["codename"]
  components ["main"]
  key node["php-hhvm"]["apt"]["key"]
end

apt_package "install hhvm" do
  package_name "hhvm"
end

include_recipe "php-hhvm::configure"
