remote_file "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}.tgz" do
  source "http://pecl.php.net/get/xhprof-#{node["php-fpm"][:xhprof_version]}.tgz"
end

execute "XHProf: unpack" do
  command "cd /tmp && tar -xzf xhprof-#{node["php-fpm"][:xhprof_version]}.tgz"
end

execute "XHProf: phpize" do
  cwd "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}"
  command "phpize"
end

execute "XHProf: ./configure" do
  cwd "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}"
  command "./configure"
end

execute "XHProf: make, make install" do
  cwd "/tmp/xhprof-#{node["php-fpm"][:xhprof_version]}"
  command "make && make install"
end

cookbook_file "#{node["php-fpm"][:prefix]}/etc/php/xhprof.ini" do
  source "xhprof.ini"
  mode "0644"
end