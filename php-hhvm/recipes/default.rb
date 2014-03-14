execute "discover apt-repository" do
  command "echo deb #{node["php-hhvm"]["apt"]["repo"]} #{node["lsb"]["codename"]} main > #{node["php-hhvm"]["apt"]["file"]}"
  not_if do
    File.exist?(node["php-hhvm"]["apt"]["file"])
  end
end

execute "update_hhvm_apt" do
  command "apt-get update -y --allow-unauthenticated"
end

apt_package "install hhvm" do
  package_name "hhvm"
  options "--allow-unauthenticated"
end

include_recipe "php-hhvm::configure"
