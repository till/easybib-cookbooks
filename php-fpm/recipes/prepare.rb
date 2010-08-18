package "libevent-dev"
package "openssl"
package "libssl-dev"
package "libcurl4-openssl-dev"
package "build-essential"
package "libtool"
package "help2man"
package "autoconf"
package "automake"

directory node["php-fpm"][:tmpdir] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

file node["php-fpm"][:logfile] do
  mode "0755"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end
