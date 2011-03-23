maintainer       "Florian Holzhauer"
maintainer_email "fh-easybib@fholzhauer.de"
license          "MIT"
description      "Installs/Configures memcached"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w[apt rvm].each do |cb|
  depends cb
end
supports "ubuntu"
