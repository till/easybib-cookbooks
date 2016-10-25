name              'qafoo-profiler'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Installs the agent to collect xhprof data for the qafoo-profiler'
version           '0.1'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'apt'
