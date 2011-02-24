include_recipe "php-fpm::prepare"

package "python-software-properties"

ppa="easybib/ppa"
execute "add #{ppa}" do
  command "add-apt-repository ppa:#{ppa}"
end

execute "update sources" do
  command "aptitude update"
end

package "php5-easybib"

include_recipe "php-fpm::configure"
