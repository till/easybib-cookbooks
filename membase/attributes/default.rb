default[:membase][:clustersize]   = 4000
default[:membase][:bucketsize]    = 4000
default[:membase][:bucketname]    = "default"
default[:membase][:adminuser]     = "admin"
default[:membase][:adminpassword] = "password"
default[:membase][:ver]           = "1.7.1"
default[:membase][:download]      = "http://packages.couchbase.com/releases/#{node[:membase][:ver]}/membase-server-community_#{node[:kernel][:machine]}_#{node[:membase][:ver]}.deb"
default[:membase][:moxidl]        = "http://packages.couchbase.com/releases/#{node[:membase][:ver]}/moxi-server_#{node[:kernel][:machine]}_#{node[:membase][:ver]}.deb"
