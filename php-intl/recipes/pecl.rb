include_recipe "php-fpm::service"
include_recipe "php-fpm::source"

require "open-uri"

package "libicu-dev"

version = open("http://pecl.php.net/rest/r/intl/latest.txt").read
release = "intl-#{version}.tgz"
so_file = "#{node["php-fpm"]["prefix"]}/lib/php/extensions/no-debug-non-zts-20090626/intl.so"

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

php_pecl "intl" do
  action [ :compile, :setup ]
  source_dir "#{Chef::Config[:file_cache_path]}/intl-#{version}"
  notifies :reload, "service[php-fpm]"
end
