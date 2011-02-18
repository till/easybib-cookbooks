package "python-software-properties"

ppa="fholzhauer/ppa"
execute "add #{ppa}" do
  command "add-apt-repository ppa:#{ppa}"
end

execute "update sources" do
  command "aptitude update"
end

package "php"

include_recipe "php-fpm::configure"
