include_recipe "apt::ppa"

case node["lsb"]["codename"]
when "lucid", "maverick", "natty", "oneiric"

  [
    "add-apt-repository #{node["redis"]["ppa"]}",
    "apt-get -y -f -m update"
  ].each do |cmd|
    execute "Running #{cmd}" do
      command cmd
    end
  end

  package "redis-server"

  include_recipe "redis::user"
  include_recipe "redis::configure"
else
  Chef::Log.error("Unsupported platform: #{node["lsb"]["codename"]}")
end
