name              'erlang-packages'
maintainer        'Till Klampaeckel'
maintainer_email  'till@php.net'
license           'BSD License'
description       'wrapper to install erlang ubuntu packages from erlang-solutions.com'
version           '0.1'
recipe            'erlang-packages', 'adds aptrepo, installs erlang-nox'
recipe            'erlang-packages::aptrepo', 'adds aptrepo'

supports 'ubuntu'

depends 'apt'
