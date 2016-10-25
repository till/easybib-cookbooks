name              'rds'
maintainer        'Ulf Harnhammar'
maintainer_email  'ulfharn@gmail.com'
license           'New BSD License'
description       'Performs backups from Amazon RDS to Amazon S3'
version           '0.0.4'
recipe            'rds::backup', 'Installs the backup system'
source_url        'https://github.com/till/easybib-cookbooks' if respond_to?(:source_url)
issues_url        'https://github.com/till/easybib-cookbooks/issues' if respond_to?(:issues_url)

supports 'ubuntu'
