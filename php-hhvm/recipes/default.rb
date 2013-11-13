execute "update_hhvm_apt" do
  command "apt-get update -y"
  action :nothing
end

execute "discover apt-repository" do
  command "echo deb #{node["php-hhvm"]["apt"]["repo"]} #{node["lsb"]["codename"]} main > #{node["php-hhvm"]["apt"]["file"]}"
  not_if do
    File.exists?(node["php-hhvm"]["apt"]["file"])
  end
  notifies :run, "execute[update_hhvm_apt]"
end

apt_package "install hhvm" do
  package_name "hhvm"
  options "--allow-unauthenticated"
end
