name 'stack-service'
maintainer 'Till Klampaeckel'
maintainer_email 'till@php.net'
license 'BSD-2-Clause'
description 'Role recipes for the service stack'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)
version '0.3'

depends 'ies-gearmand'
depends 'logrotate'
depends 'rabbitmq'
depends 'statsd'
depends 'nodejs'
depends 'ies'
