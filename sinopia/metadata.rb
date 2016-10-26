name 'sinopia'
maintainer 'Barthelemy Vessemont'
maintainer_email 'bvessemont@gmail.com'
license 'Apache 2.0'
description 'Install a sinopia NPM server (cache & private repo)
See : https://github.com/rlidwka/sinopia/'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'
source_url        'https://github.com/BarthV/sinopia-cookbook' if respond_to?(:source_url)
issues_url        'https://github.com/BarthV/sinopia-cookbook/issues' if respond_to?(:issues_url)

supports 'ubuntu', '>= 12.04'
supports 'redhat'
supports 'centos'
supports 'fedora'

depends 'apt'
depends 'nodejs', '~> 2.0'
#depends 'user'
depends 'logrotate'
