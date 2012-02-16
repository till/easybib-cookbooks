php_version = node[:php_phar][:version]

ruby_block "determine PHP environment" do
  current_node = node
  block do
    current_node[:php_phar][:php_cmd]     = `which php`.strip
    current_node[:php_phar][:php_ext_dir] = `#{current_node[:php_phar][:php_cmd]} -r 'echo ini_get("extension_dir");'`.strip

    if current_node[:php_phar][:php_ext_dir].empty?
      raise "Could not determine PHP's extension_dir"
    end
    #Chef::Log.debug(node[:php_phar][:php_ext_dir])
  end
end

package "autoconf"

remote_file "/tmp/php-#{php_version}.tar.gz" do
  source "http://us.php.net/get/php-#{php_version}.tar.gz/from/us.php.net/mirror"
end

execute "test tar" do
  command "tar -zxvf php-#{php_version}.tar.gz"
  cwd     "/tmp"
  only_if do
    File.exists?("/tmp/php-#{php_version}.tar.gz")
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

execute "copy phar.so" do
  command "cp modules/phar.so #{node[:php_phar][:php_ext_dir]}"
  cwd     compile_dir
  not_if do
    File.exists?("#{node[:php_phar][:php_ext_dir]}/phar.so")
  end
end

include_recipe "php-phar::configure"
