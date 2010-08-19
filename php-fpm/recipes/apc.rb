apc_version = "3.1.4"

remote_file "/tmp/APC-#{apc_version}.tgz" do
  source "http://pecl.php.net/get/APC-#{apc_version}.tgz"
  checksum "53d8442e8b7e3804537d14e5776962cfdc5ae4d8"
end

execute "APC: unpack" do
  command "cd /tmp && tar -xzf APC-#{apc_version}.tgz"
end

execute "APC: ./configure" do
  cwd "/tmp/APC-#{apc_version}"
  environment "HOME" => "/root"
  command "./configure"
end

execute "APC: make, make install" do
  cwd "/tmp/APC-#{apc_version}"
  command "make && make install"
end

execute "add apc.so to php.ini" do
  command "echo 'extension=apc.so' >> /usr/local/lib/php.ini"
end