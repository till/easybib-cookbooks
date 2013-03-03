# recipe for developers
#package "php5-easybib-apc" do
#  action :remove
#end

#package "php5-easybib-pdo-sqlite"
#package "php5-easybib-apc"
#package "php5-easybib-xhprof"

execute "pear: auto_discover = 1" do
  command "pear config_set auto_discover 1"
end

execute "pear: phpunit" do
  command "pear install -f --alldeps pear.phpunit.de/phpunit"
end
