include_recipe "percona-server::repository"

case node["percona-server"][:version]
  when "5.0"
    package "percona-sql-common"
    package "percona-sql-client-5.0"
    package "percona-sql-server-5.0"
  when "5.1"
    package "percona-server-common"
    package "percona-server-client-5.1"
    package "percona-server-server-5.1"
  else
    # wat?
    Chef::Log.debug("Unknown version: #{node["percona-server"][:version]}")
end
