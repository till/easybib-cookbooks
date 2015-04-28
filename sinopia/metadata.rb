name 'sinopia'
maintainer 'Barthelemy Vessemont'
maintainer_email 'bvessemont@gmail.com'
license 'Apache 2.0'
description 'Install a sinopia NPM server (cache & private repo)
See : https://github.com/rlidwka/sinopia/'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

supports 'ubuntu', '>= 12.04'
supports 'redhat'
supports 'centos'
supports 'fedora'

depends 'apt'
depends 'nodejs', '~> 2.0'
depends 'user'
depends 'logrotate'
