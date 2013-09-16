include_recipe "php-fpm::source"

if node["xdebug"]["version"] == 'latest'
  xdebug_version = ""
else
  xdebug_version = "-#{node["xdebug"]["version"]}"
end

php_pecl "xdebug#{xdebug_version}"

include_recipe "php-xdebug::configure"
