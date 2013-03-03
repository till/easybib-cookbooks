maintainer        "Till Klampaeckel"
maintainer_email  "till@php.net"
license           "BSD License"
description       "Tools we'd like on all servers."
version           "0.1"
recipe            "easybib-base::setup", "Installs them."
recipe            "easybib-base::awscommand", "Installs Timothy Kay's aws command"
recipe            "easybib-base::nginxstats", "Script to show current stats."
recipe            "easybib-base::cron", "Configure MAILTO= in crontab"

supports 'ubuntu'