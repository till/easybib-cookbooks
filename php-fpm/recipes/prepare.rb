package "libevent-dev"
package "openssl"
package "libssl-dev"
package "libcurl4-openssl-dev"
package "build-essential"
package "libtool"
package "help2man"
package "autoconf"
package "automake"

execute "create PHP's logfile" do
  command "touch #{node["php-fpm"][:logfile]}"
end

execute "create standard temporary directory" do
  command "mkdir -p #{node["php-fpm"][:tmpdir]}"
  command "chown #{node["php-fpm"][:user]}:#{node["php-fpm"][:group]} #{node["php-fpm"][:tmpdir]}"
end
  

execute "ensure correct permissions on PHP's log file" do
  command "chown -R #{node["php-fpm"][:user]}:#{node["php-fpm"][:group]} #{node["php-fpm"][:logfile]}"
end
