execute "init nodejs launchpad repo" do
  command "add-apt-repository ppa:chris-lea/node.js-devel"
end

execute "update sources.list" do
  command "apt-get update"
end

package "nodejs"
