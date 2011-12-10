default[:percona]           = {}
default[:percona][:version] = "5.1"
default[:percona][:key]     = "1C4CBDCDCD2EFD2A"

# set if scalarium is not available
set_unless[:mysql]                        = {}
set_unless[:mysql][:server_root_password] = "plzhax0rme"

set_unless[:xtrabackup]           = {}
set_unless[:xtrabackup][:dir]     = "/var/backups"
set_unless[:xtrabackup][:weekday] = 6
set_unless[:xtrabackup][:hour]    = 8
set_unless[:xtrabackup][:minute]  = 0
