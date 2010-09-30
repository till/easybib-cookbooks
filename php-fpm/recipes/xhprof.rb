package "graphviz"

remote_file "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}.tgz" do
  source "http://pecl.php.net/get/xhprof-#{node["php-fpm"][:xhprof_version]}.tgz"
end

execute "XHProf: unpack" do
  command "cd /tmp && tar -xzf xhprof-#{node["php-fpm"][:xhprof_version]}.tgz"
end

## Due to a bug, we have to build xhprof by hand
## Reference: http://pecl.php.net/bugs/bug.php?id=16438

execute "XHProf: phpize" do
  cwd "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}/extension"
  command "phpize"
end

execute "XHProf: ./configure" do
  cwd "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}/extension"
  command "./configure"
end

execute "XHProf: make, make install" do
  cwd "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}/extension"
  command "make && make install"
end

remote_file "#{node["php-fpm"][:prefix]}/etc/php/xhprof.ini" do
  source "xhprof.ini"
  mode "0644"
end
