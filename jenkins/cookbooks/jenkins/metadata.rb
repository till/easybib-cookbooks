maintainer       "Florian Holzhauer"
maintainer_email "fh-aaoishd@fholzhauer.de"
license          "MIT"
description      "Installs/Configures jenkins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w[apt rvm].each do |cb|
  depends cb
end
supports "ubuntu"
