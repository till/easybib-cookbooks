remote_file "/tmp/APC-#{node["php-fpm"][:apc_version]}.tgz" do
  source "http://pecl.php.net/get/APC-#{node["php-fpm"][:apc_version]}.tgz"
  checksum "53d8442e8b7e3804537d14e5776962cfdc5ae4d8"
end

execute "APC: unpack" do
  command "cd /tmp && tar -xzf APC-#{node["php-fpm"][:apc_version]}.tgz"
end

execute "APC: phpize" do
  cwd "/tmp/APC-#{node["php-fpm"][:apc_version]}"
  command "phpize"
end

execute "APC: ./configure" do
  cwd "/tmp/APC-#{node["php-fpm"][:apc_version]}"
  command "./configure"
end

execute "APC: make, make install" do
  cwd "/tmp/APC-#{node["php-fpm"][:apc_version]}"
  command "make && make install"
end

cookbook_file "#{node["php-fpm"][:prefix]}/etc/php/apc.ini" do
  source "apc.ini"
  mode "0644"
end