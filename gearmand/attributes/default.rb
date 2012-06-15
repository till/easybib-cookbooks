default[:gearmand]        = {}
default[:gearmand][:user] = "gearman"
default[:gearmand][:port] = 31337
default[:gearmand][:log]  = "--syslog --verbose INFO" #or --logfile=/path/to/whatever
default[:gearmand][:name] = "gearmand-easybib" # name of our package and init.d, default

# these are relevant for when we compile from source (current default)
default[:gearmand][:prefix]           = "/opt/easybib"
default[:gearmand][:source]           = {}
default[:gearmand][:source][:version] = "0.28"
default[:gearmand][:source][:flags]   = "--disable-libpq --disable-libmemcached --without-sqlite3 --disable-libdrizzle"

# these are for silverline
default[:silverline][:gearmand_name] = "gearmand"
