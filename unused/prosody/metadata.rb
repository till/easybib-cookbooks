name              'prosody'
maintainer        'Till Klampaeckel, Florian Holzhauer'
maintainer_email  'till@php.net'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'
supports 'freebsd'

depends 'easybib'
depends 'ies-mysql'

license           'BSD License'
