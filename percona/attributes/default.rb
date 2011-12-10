default["percona-server"] = {}
default["percona-server"][:version] = "5.1"
default["percona-server"][:key]     = "1C4CBDCDCD2EFD2A"

# set if scalarium is not available
set_unless[:mysql]                        = {}
set_unless[:mysql][:server_root_password] = "plzhax0rme"

set_unless[:xtrabackup]       = {}
set_unless[:xtrabackup][:dir] = "/var/backups"
