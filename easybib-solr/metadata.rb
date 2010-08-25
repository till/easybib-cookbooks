maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Recipes to setup an EC2 instance for our solr setup."
version           "0.1"
recipe            "easybib-solr::solr", "Checks out all apps and does some config for solr."
recipe            "easybib-solr::prepare", "Installs dependencies for Solr, creates directories."
recipe            "easybib-solr::raid", "Setup a raid of EBS volumes."

supports 'ubuntu'