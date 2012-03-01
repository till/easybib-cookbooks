# This recipe is necessary to do a simple `pecl install gearman` on Ubuntu Lucid

deps = ["libgearman-dev", "libgearman-server-dev", "libgearman-server0",
  "libgearman2", "libuuid1", "uuid-dev", "uuid-runtime"]

ext_dir = `php -r "echo ini_get('extension_dir');"`.strip

lsb_desc = "/usr/lib/libgearman.la"

deps.each do |p|
  package p
  only_if node[:lsb][:codename] == 'lucid'
end

# http://mgribov.blogspot.com/2010/05/gearman-pecl-package-on-ubuntu-lucid.html
execute "fix #{lib_desc}" do
  command "sed -i \"s/dependency_libs=' -L\/usr\/lib \/usr\/lib\/libuuid.la/dependency_libs=' -L\/usr\/lib -luuid'\" #{lib_desc}"
  only_if !File.exist?("#{ext_dir}/gearman.so") && node[:lsb][:codename] == 'lucid'
end

execute "pecl install" do
  command "pecl install gearman-#{node[:gearman][:pecl]}"
  only_if !File.exist?("#{ext_dir}/gearman.so") && node[:lsb][:codename] == 'lucid'
end
