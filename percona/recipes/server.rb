include_recipe "percona::repository"
include_recipe "percona::client"

case node[:percona][:version]
  when "5.0"
    fail "5.0 is gone!"
  when "5.1"
    package "percona-server-common-5.1"
    package "percona-server-server-5.1"
  when "5.5"
    package "percona-server-common-5.5"
    package "percona-server-server-5.5"
  else
    # wat?
    Chef::Log.debug("Unknown version: #{node[:percona][:version]}")
end
