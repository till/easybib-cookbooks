include_recipe "apt::ppa"

execute "init nodejs launchpad repo" do
  command "add-apt-repository ppa:chris-lea/node.js-devel"
end

execute "update sources.list" do
  command "apt-get -y -f -q update"
end

package "nodejs"
