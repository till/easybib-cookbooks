name             "virtualbox"
maintainer       "Bradley D Smith"
maintainer_email "bradleydsmith@gmail.com"
license          "Apache 2.0"
description      "Installs virtualbox"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.3"

%w{ubuntu debian centos redhat mac_os_x windows fedora}.each do |os|
  supports os
end

#depends "dmg"
#depends "windows"
depends "apt"
#depends "yum", '~> 3.1'
#depends "apache2"
