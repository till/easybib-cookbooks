# install redis from a ppa to avoid compiling, etc.

package "python-software-properties"

execute "add Chris Lea's PPA" do
  command "add-apt-repository ppa:chris-lea/redis-server"
end

execute "update sources" do
  command "apt-get update"
end

execute "install redis" do
  command "apt-get install redis"
end
