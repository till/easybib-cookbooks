package "libsqlite3-dev"
package "autoconf"

ohai "reload_php" do
  action :reload
  plugin "php_fpm"
end

php_source = "/tmp/php-#{node["php-pdo_sqlite"]["version"]}"
php_archive = "#{php_source}.tar.gz"

remote_file php_archive do
 checksum node["php-pdo_sqlite"]["checksum"]
 source "http://de3.php.net/get/php-#{node["php-pdo_sqlite"]["version"]}.tar.gz/from/de1.php.net/mirror"
end

execute "tar -zxf #{php_archive}" do
  cwd "/tmp"
end

module_source = "#{php_source}/ext/pdo_sqlite"

commands = [
  "phpize",
  "./configure",
  "make",
  "cp modules/pdo_sqlite.so #{node[:languages][:php_fpm][:extension_dir]}",
  "echo 'extension=pdo_sqlite.so' >> #{node["php-fpm"][:prefix]}/etc/php/pdo_sqlite.ini"
]

commands.each do |command|
  execute command do
    cwd module_source
  end
end
