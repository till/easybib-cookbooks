name 'sinopia-github'
maintainer 'JoelleGilley'
maintainer_email 'joel.gilley@imagineeasy.com'
license 'BSD License'
description 'Installs sinopia-github'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)
version '0.0.1'
supports 'ubuntu', '>= 12.04'
supports 'redhat'
supports 'centos'
supports 'fedora'
depends 'sinopia'
