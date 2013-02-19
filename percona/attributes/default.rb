default[:percona]            = {}
default[:percona][:version]  = "5.5"
default[:percona][:key]      = "1C4CBDCDCD2EFD2A"
default[:percona][:user]     = "root"
default[:percona][:password] = ""

# set if opsworks is not available
set_unless[:mysql]                        = {}
set_unless[:mysql][:server_root_password] = "plzhax0rme"

set_unless[:xtrabackup]                = {}
set_unless[:xtrabackup][:dir]          = "/var/backups"
set_unless[:xtrabackup][:weekday]      = 6
set_unless[:xtrabackup][:hour]         = 8
set_unless[:xtrabackup][:minute]       = 0
set_unless[:xtrabackup][:aws]          = {}
set_unless[:xtrabackup][:aws][:key]    = ''
set_unless[:xtrabackup][:aws][:secret] = ''
set_unless[:xtrabackup][:s3_bucket]    = 'plz-set-this'
set_unless[:xtrabackup][:processor]    = '/usr/bin/easybib-backup-processor'
set_unless[:xtrabackup][:uploader]     = '/usr/bin/easybib-backup-uploader'
