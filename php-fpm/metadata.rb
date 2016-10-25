name              'php-fpm'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'PHP License'
description       'Installs and configures PHP with fpm patch.'
version           '0.4'
recipe            'php-fpm::default', 'Installs our custom PHP package from launchpad'
recipe            'php-fpm::download', 'Downloads the source and extracts it'
recipe            'php-fpm::prepare', 'Creates prequesites like user and directories'
recipe            'php-fpm::dependencies', 'Install dependencies'
recipe            'php-fpm::ohai', 'php-fpm ohai plugin installer'
recipe            'php-fpm::monit', 'php-fpm monit monitoring'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'

depends 'easybib'
depends 'monit'
depends 'ohai'
depends 'php'
depends 'awscli'
