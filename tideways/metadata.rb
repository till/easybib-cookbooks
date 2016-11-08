name              'tideways'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD-2-Clause'
description       'Install and configure tideways daemon and PHP extension'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)
version           '0.1'

depends 'apt'
depends 'easybib'
depends 'php'
depends 'php-fpm'
