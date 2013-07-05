package "libsqlite3-dev"
package "autoconf"

php_source = "/tmp/php-#{node["php-pdo_sqlite"]["version"]}"
php_archive = "#{php_source}.tar.gz"

remote_file "#{php_archive}" do
 checksum node["php-pdo_sqlite"]["checksum"]
 source "http://de3.php.net/get/php-#{node["php-pdo_sqlite"]["version"]}.tar.gz/from/de1.php.net/mirror"
end

execute "tar -zxf #{php_archive}" do
  cwd "/tmp"
end

module_source = "#{php_source}/ext/pdo_sqlite"
ext_dir = `php -r 'echo ini_get("extension_dir");'`.strip

commands = [
  "phpize",
  "./configure",
  "make",
  "cp modules/pdo_sqlite.so #{ext_dir}",
  "echo 'extension=pdo_sqlite.so' >> /usr/local/etc/php/pdo_sqlite.ini"
]

commands.each do |command|
  execute "#{command}" do
    cwd module_source
  end
end
