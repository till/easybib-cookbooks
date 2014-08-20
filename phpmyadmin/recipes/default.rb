include_recipe "apt::ppa"

easybib_launchpad "ppa:nijel/phpmyadmin" do
  action :discover
end

package "phpmyadmin"
