set_unless[:munin]           = {}
set_unless[:munin][:lib_dir] = '/vol/ganglia/munin/lib'
set_unless[:munin][:version] = '1.4.5'
set_unless[:munin][:user]    = 'munin'
set_unless[:munin][:group]   = 'munin'

default[:munin][:prefix]  = '/usr/local'
default[:munin][:www_dir] = '/var/www/munin'
default[:munin][:log_dir] = '/mnt/log/munin'
default[:munin][:graph]   = 'cgi'

set_unless[:sysop_email] = 'foo@example.org'
