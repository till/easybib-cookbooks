name 'stack-test'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)
version           '0.1'
maintainer 'Till Klampaeckel'
maintainer_email 'till@php.net'

depends 'supervisor'
depends 'ies'
depends 'easybib'
depends 'php-fpm'
depends 'nginx-app'
