# install redis from a ppa to avoid compiling, etc.
include_recipe "apt::ppa"

case node[:lsb][:codename]
when "karmic"
  Chef::Log.error("Recipe does not support karmic.")
when "lucid"
when "maverick"
when "natty"
when "oneiric"
  execute "add Chris Lea's PPA" do
    command "add-apt-repository ppa:chris-lea/redis-server"
  end

  execute "update sources" do
    command "apt-get -y -f -m update"
  end

  package "redis-server"

  include_recipe "redis::user"
  include_recipe "redis::configure"
else
  Chef::Log.error("Unsupported platform: #{node[:lsb][:codename]}")
end
