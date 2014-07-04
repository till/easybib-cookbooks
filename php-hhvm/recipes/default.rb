apt_package "install add-apt-repository" do
  package_name "python-software-properties"
end

execute "add libboost ppa" do
  command <<-EOF
    add-apt-repository -y ppa:mapnik/boost
    wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
  EOF
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
