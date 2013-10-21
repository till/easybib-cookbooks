include_recipe "apt::ppa"

easybib_launchpad "ppa:chris-lea/node.js-devel" do
  action :discover
end

package "nodejs"
