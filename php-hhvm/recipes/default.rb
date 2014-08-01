include_recipe "apt"
include_recipe "apt::ppa"

easybib_launchpad node["php-hhvm"]["boost"]["ppa"] do
  action :discover
  only_if do
    node["lsb"]["release"].to_f < 14.04
  end
end

apt_repository "hhvm" do
  uri node["php-hhvm"]["apt"]["repo"]
  distribution node["lsb"]["codename"]
  components ["main"]
  key node["php-hhvm"]["apt"]["key"]
end

apt_package "install hhvm" do
  package_name "hhvm"
end

include_recipe "php-hhvm::configure"
