maintainer       "Boundary"
maintainer_email "ops@boundary.com"
license          "Apache 2.0"
description      "Installs/Configures bprobe"
long_description "Installs/Configures bprobe"
version          "0.1"

%w{ ubuntu centos }.each do |os|
  supports os
end

depends "yum"
depends "apt"
