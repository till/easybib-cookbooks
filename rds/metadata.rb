name              "rds"
maintainer        "Ulf Harnhammar"
maintainer_email  "ulfharn@gmail.com"
license           "New BSD License"
description       "Performs backups from Amazon RDS to Amazon S3"
version           "0.0.4"
recipe            "rds::backup", "Installs the backup system"

supports 'ubuntu'
