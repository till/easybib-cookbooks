include_recipe "apt::ppa"

execute "discover ppa" do
  command "add-apt-repository ppa:nijel/phpmyadmin"
end

execute "update sources" do
  command "apt-get update"
end

package "phpmyadmin"
