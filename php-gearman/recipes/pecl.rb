# This recipe is necessary to do a simple `pecl install gearman` on Ubuntu Lucid
include_recipe "php-fpm::source"

deps = ["libgearman-dev", "libgearman-server-dev", "libgearman-server0",
  "libgearman2", "libuuid1", "uuid-dev", "uuid-runtime"]

lsb_desc = "/usr/lib/libgearman.la"

deps.each do |p|
  package p
  only_if node["lsb"]["codename"] == 'lucid'
end

# http://mgribov.blogspot.com/2010/05/gearman-pecl-package-on-ubuntu-lucid.html
execute "fix #{lib_desc}" do
  command "sed -i \"s/dependency_libs=' -L\/usr\/lib \/usr\/lib\/libuuid.la/dependency_libs=' -L\/usr\/lib -luuid'\" #{lib_desc}"
  only_if node["lsb"]["codename"] == 'lucid'
end

php_pecl "gearman" do
  version node["gearman"]["pecl"]
  action [ :install, :setup ]
end
