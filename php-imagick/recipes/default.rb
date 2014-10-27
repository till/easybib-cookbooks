package 'autoconf'
package 'imagemagick'
package 'libmagickwand-dev'

local_name = "imagick-#{node['php-imagick']['version']}"
gzipped = "#{local_name}.tgz"

remote_file "#{Chef::Config[:file_cache_path]}/#{gzipped}" do
  source "http://pecl.php.net/get/#{gzipped}"
end

execute "extract download: #{gzipped}" do
  command "tar -zxvf #{Chef::Config[:file_cache_path]}/#{gzipped}"
  cwd Chef::Config[:file_cache_path]
  not_if do
    File.exist?("#{Chef::Config[:file_cache_path]}/#{local_name}")
  end
end

php_pecl 'imagick' do
  action [:compile, :setup]
  source_dir "#{Chef::Config[:file_cache_path]}/#{local_name}"
  version node['php-imagick']['version']
end
