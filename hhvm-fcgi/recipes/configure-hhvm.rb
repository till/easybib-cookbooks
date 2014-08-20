include_recipe "apt"
include_recipe "apt::ppa"
include_recipe "aptly::repo"

apt_repository "hhvm" do
  uri node["hhvm-fcgi"]["apt"]["repo"]
  distribution node["lsb"]["codename"]
  components ["main"]
  key node["hhvm-fcgi"]["apt"]["key"]
end

apt_package "install hhvm" do
  package_name "hhvm#{node["hhvm-fcgi"]["build"]}"
end
