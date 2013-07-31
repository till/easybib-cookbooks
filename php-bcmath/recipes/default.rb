include_recipe "php-bcmath::dependencies"

php_source = "/tmp/php-#{node["php-bcmath"]["version"]}"
php_archive = "#{php_source}.tar.gz"

remote_file php_archive do
 checksum node["php-bcmath"]["checksum"]
 source "http://de3.php.net/get/php-#{node["php-bcmath"]["version"]}.tar.gz/from/de1.php.net/mirror"
end

execute "tar -zxf #{php_archive}" do
  cwd "/tmp"
end

module_source = "#{php_source}/ext/bcmath"
ext_dir = `php -r 'echo ini_get("extension_dir");'`.strip

commands = [
  "phpize",
  "./configure",
  "make",
  "cp modules/bcmath.so #{ext_dir}", "echo 'extension=bcmath.so' >> #{node["php-fpm"]["prefix"]}etc/php/bcmath.ini"
]

commands.each do |command|
  execute command do
    cwd module_source
  end
end
