name 'fake-s3'

supports 'ubuntu'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
version           '0.1'
depends 'easybib'
depends 'supervisor'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)
