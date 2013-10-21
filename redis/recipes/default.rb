include_recipe "apt::ppa"

case node["lsb"]["codename"]
when "lucid", "maverick", "natty", "oneiric"

  easybib_launchpad node["redis"]["ppa"] do
    action :discover
  end

  package "redis-server"

  include_recipe "redis::user"
  include_recipe "redis::configure"
else
  Chef::Log.error("Unsupported platform: #{node["lsb"]["codename"]}")
end
