name              "nginx-lb"
maintainer        "Ulf Harnhammar"
maintainer_email  "ulfharn@gmail.com"
license           "BSD License"
description       "Configures nginx as an SSL termination reverse proxy"
version           "0.0.1"
recipe            "nginx-lb::default", "Installs nginx"
recipe            "nginx-lb::service", "Sets nginx up as a service"

supports "ubuntu"

depends "nginx-app"
