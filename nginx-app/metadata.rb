name              'nginx-app'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'Installs and configures an nginx for our appservers.'
version           '0.1'
recipe            'nginx-app::server', 'Installs Nginx'
recipe            'nginx-app::configure', 'Configures virtualhost, etc.'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

depends 'rsyslogd'
depends 'php-fpm'
depends 'apt'
depends 'aptly'
depends 'easybib'
depends 'ies-ssl'
depends 'ies-letsencrypt'
depends 'supervisor'

supports 'ubuntu'
