# install redis from a ppa to avoid compiling, etc.
include_recipe "apt::ppa"

execute "add Chris Lea's PPA" do
  command "add-apt-repository ppa:chris-lea/redis-server"
end

execute "update sources" do
  command "apt-get -y -f -m update"
end

package "redis-server"

include_recipe "redis::user"
include_recipe "redis::service"
include_recipe "redis::configure"
