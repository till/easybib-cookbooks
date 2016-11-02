name             'apt-spy2'
maintainer       'Till Klampaeckel'
maintainer_email 'till@php.net'
license          'New BSD license'
description      'Installs apt-spy2'
version          '0.1'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url 'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'ruby-brightbox'
