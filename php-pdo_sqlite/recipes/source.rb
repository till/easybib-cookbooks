include_recipe "php-fpm::source"

package "libsqlite3-dev"

php_source = "/tmp/php-#{node["php-pdo_sqlite"]["version"]}"
php_archive = "#{php_source}.tar.gz"

remote_file php_archive do
 checksum node["php-pdo_sqlite"]["checksum"]
 source "http://de3.php.net/get/php-#{node["php-pdo_sqlite"]["version"]}.tar.gz/from/de1.php.net/mirror"
end

execute "tar -zxf #{php_archive}" do
  cwd "/tmp"
end

php_pecl "pdo_sqlite" do
  action [ :compile, :setup ]
  source_dir "#{php_source}/ext/pdo_sqlite"
end
