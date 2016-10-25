name              'apache-couchdb'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Setup Apache CouchDB'
version           '0.1'
recipe            'apache-couchdb::default', 'Installs Apache CouchDB'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'ies-apt'
depends 'logrotate'
