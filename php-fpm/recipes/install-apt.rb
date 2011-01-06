package "python-software-properties"

execute "add Lee's repo" do
  command "add-apt-repository ppa:lee-rockingtiger/php-fpm-optimized"
end

execute "update sources" do
  command "aptitude update"
end

package "php5-fpm"
package "php5-cli"
package "php5-curl"
package "php5-tidy"
