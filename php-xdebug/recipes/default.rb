if node[:xdebug][:version] == 'latest'
  xdebug_version = ""
else
  xdebug_version = "-#{node[:xdebug][:version]}"
end

package "autoconf"

php_pecl "xdebug#{xdebug_version}"

include_recipe "php-xdebug::configure"
