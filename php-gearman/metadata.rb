name              'php-gearman'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Installs ext/gearman for PHP'
version           '0.1'
recipe            'php-gearman::default', 'Installs ext/gearman from our Launchpad repo.'

depends 'php-fpm'
depends 'php'
depends 'apt'

supports 'ubuntu'
