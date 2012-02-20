default[:couchdb]                  = {}
default[:couchdb][:version]        = '1.0.3'
default[:couchdb][:datadir]        = '/couchdb/'
default[:couchdb][:logdir]         = '/mnt/couchdb/log'
default[:couchdb][:viewdir]        = '/views/'
default[:couchdb][:backup]         = true
default[:couchdb][:backupdir]      = '/backup'
default[:couchdb][:gid]            = 2000
default[:couchdb][:replica]        = false
default[:couchdb][:backup_backlog] = 10
default[:couchdb][:port]           = 5984

default[:couchbase]      = {}
default[:couchbase][:dl] = "http://packages.couchbase.com/releases/couch/1.1.2/couchbase-single-server-community_x86_64_1.1.2.deb"

set_unless[:couchdb_admins] = {}

default[:silverline][:couchdb_name] = "couchdb"

if attribute?(:scalarium)
  default[:silverline][:environment] = node[:scalarium][:cluster][:name].gsub(/\s/,'')
else
  default[:silverline][:environment] = "production"
end
