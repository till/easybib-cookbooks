php_version = node[:php_phar][:version]

package "autoconf"

remote_file "/tmp/php-#{php_version}.tar.gz" do
  source "http://us.php.net/get/php-#{php_version}.tar.gz/from/us.php.net/mirror"
  only_if do
    !File.exists?("/tmp/php-#{php_version}.tar.gz") || !File.directory?("/tmp/php-#{php_version}")
  end
end

execute "extract tar" do
  command "tar -zxvf php-#{php_version}.tar.gz"
  cwd     "/tmp"
  creates "/tmp/php-#{php_version}"
  only_if do
    File.exists?("/tmp/php-#{php_version}.tar.gz")
  end
end

compile_dir = "/tmp/php-#{php_version}/ext/phar"

execute "phpize" do
  cwd compile_dir
  not_if do
    File.exists?("#{compile_dir}/modules/phar.so")
  end
end

# the CFLAGS are experimental
execute "build phar" do
  command 'CFLAGS="-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" ./configure --disable-all --enable-phar=shared && make'
  cwd     compile_dir
  not_if do
    File.exists?("#{compile_dir}/modules/phar.so")
  end
end

script "copy phar.so into extension_dir" do
  interpreter "bash"
  cwd         compile_dir
  code <<-EOH
  EXT_DIR=`/usr/local/bin/php -r 'echo ini_get("extension_dir");'`
  cp -vf modules/phar.so $EXT_DIR
  EOH
end

include_recipe "php-phar::configure"
