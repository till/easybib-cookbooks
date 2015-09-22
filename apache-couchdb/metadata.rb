name              'apache-couchdb'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Setup Apache CouchDB'
version           '0.1'
recipe            'apache-couchdb::default', 'Installs Apache CouchDB'

supports 'ubuntu'

depends 'apt'
depends 'logrotate'
