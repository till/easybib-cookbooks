include_recipe "php-bcmath::dependencies"
include_recipe "php-fpm::source"

php_source = "/tmp/php-#{node["php-bcmath"]["version"]}"
php_archive = "#{php_source}.tar.gz"

remote_file php_archive do
  checksum node["php-bcmath"]["checksum"]
  source "http://de3.php.net/get/php-#{node["php-bcmath"]["version"]}.tar.gz/from/de1.php.net/mirror"
  not_if do
    File.exists?(php_archive)
  end
end

execute "tar -zxf #{php_archive}" do
  cwd "/tmp"
end

php_pecl "bcmath" do
  action [ :compile, :setup]
  source_dir "#{php_source}/ext/bcmath"
end
