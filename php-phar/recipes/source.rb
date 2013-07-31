php_version = node[:php_phar][:version]

package "autoconf"

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

execute "phpize" do
  cwd compile_dir
  not_if do
    File.exists?("#{compile_dir}/modules/phar.so")
  end
end

case node[:lsb][:codename]
when 'lucid'
  # the CFLAGS are experimental
  build_cmd = 'CFLAGS="-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" ./configure --disable-all --enable-phar=shared && make'
when 'karmic'
  build_cmd = './configure --disable-all --enable-phar=shared && make'
else
  raise "Unsupported platform #{node[:lsb][:codename]}"
end

execute "build phar" do
  command build_cmd
  cwd     compile_dir
  not_if do
    File.exists?("#{compile_dir}/modules/phar.so")
  end
end

script "copy phar.so into extension_dir" do
  interpreter "bash"
  cwd         compile_dir
  code <<-EOH
  PHP_CMD=$(which php)
  EXT_DIR=$($PHP_CMD -r 'echo ini_get("extension_dir");')
  cp -vf modules/phar.so $EXT_DIR
  EOH
end

include_recipe "php-phar::configure"
