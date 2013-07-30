name              "unfuddle-ssl-fix"
maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Install a SSL certificate to stop subversion from complaining"
version           "0.1"
recipe            "unfuddle-ssl-fix::install", "Install SSL cert and add it to subversion's config"

supports 'ubuntu'
depends "subversion"
