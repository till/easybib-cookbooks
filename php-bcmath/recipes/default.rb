php_source = "/tmp/php-#{node["php-bcmath"]["version"]}"
php_archive = "#{php_source}.tar.gz"

include_recipe "php-fpm"

package "autoconf"

remote_file "#{php_archive}" do
 checksum node["php-bcmath"]["checksum"]
 source "http://de3.php.net/get/php-#{node["php-bcmath"]["version"]}.tar.gz/from/de1.php.net/mirror"
end

execute "tar -zxf #{php_archive}" do
  cwd "/tmp"
end

module_source = "#{php_source}/ext/bcmath"

execute "phpize" do
  cwd module_source
end

execute "./configure" do
  cwd module_source
end

execute "make" do
  cwd module_source
end

ext_dir = `php -r 'echo ini_get("extension_dir");'`.strip

execute "cp modules/bcmath.so #{ext_dir}" do
  cwd module_source
end

execute "echo 'extension=bcmath.so' >> /usr/local/etc/php/bcmath.ini"
