include_recipe "percona::repository"

case node[:percona][:version]
  when "5.0"
    raise "5.0 is gone!"
  when "5.1"
    package "percona-server-common-5.1"
    package "percona-server-client-5.1"
  when "5.5"
    package "percona-server-common-5.5"
    package "percona-server-client-5.5"
  else
    # wat?
    Chef::Log.debug("Unknown version: #{node[:percona][:version]}")
end
