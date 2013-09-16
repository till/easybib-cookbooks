include_recipe "php-fpm::source"

php_version = node[:php_phar][:version]

remote_file "#{Chef::Config[:file_cache_path]}/php-#{php_version}.tar.gz" do
  source "http://us.php.net/get/php-#{php_version}.tar.gz/from/us.php.net/mirror"
  only_if do
    !File.exists?("#{Chef::Config[:file_cache_path]}/php-#{php_version}.tar.gz") || !File.directory?("#{Chef::Config[:file_cache_path]}/php-#{php_version}")
  end
end

execute "extract tar" do
  command "tar -zxvf php-#{php_version}.tar.gz"
  cwd     Chef::Config[:file_cache_path]
  creates "#{Chef::Config[:file_cache_path]}/php-#{php_version}"
  only_if do
    File.exists?("#{Chef::Config[:file_cache_path]}/php-#{php_version}.tar.gz")
  end
end

compile_dir = "#{Chef::Config[:file_cache_path]}/php-#{php_version}/ext/phar"

php_pecl "phar" do
  action :compile
  source_dir compile_dir
  cflags "-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
end

include_recipe "php-phar::configure"
