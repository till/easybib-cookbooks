include_recipe "php-fpm::service"

require "open-uri"

package "libicu-dev"
package "autoconf"

version = open("http://pecl.php.net/rest/r/intl/latest.txt").read
release = "intl-#{version}.tgz"
so_file = "#{node["php-fpm"][:prefix]}/lib/php/extensions/no-debug-non-zts-20090626/intl.so"

remote_file "#{Chef::Config[:file_cache_path]}/#{release}" do
  source "http://pecl.php.net/get/#{release}"
  not_if do
    File.exists?(so_file)
  end
end

execute "tar -zxf #{Chef::Config[:file_cache_path]}/#{release}"do
  cwd Chef::Config[:file_cache_path]
  only_if do
    File.exists?("#{Chef::Config[:file_cache_path]}/#{release}")
  end
end

commands = [
  "phpize",
  "./configure",
  "make",
  "cp ./modules/intl.so #{so_file}",
]

commands.each do |command|
  execute command do
    cwd "#{Chef::Config[:file_cache_path]}/intl-#{version}"
    not_if do
      File.exists?(so_file)
    end
  end
end

execute "load .so" do
  command "echo 'extension=intl.so' >> #{node["php-fpm"][:prefix]}/etc/php/intl.ini"
  not_if do
    File.exists?("#{node["php-fpm"][:prefix]}/etc/php/intl.ini")
  end
end

service "php-fpm" do
  action :reload
end
