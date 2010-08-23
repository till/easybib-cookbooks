include_recipe "php-fpm::prepare"

php_installed_version = `which php >> /dev/null && php -v|grep #{node["php-fpm"][:version]}|awk '{ print substr($2,1,5) }'`

php_already_installed = lambda do
  php_installed_version == node["php-fpm"][:version]
end

remote_file "/tmp/php-#{node["php-fpm"][:version]}.tgz" do
  source "http://www.php.net/get/php-#{node["php-fpm"][:version]}.tar.gz/from/www.php.net/mirror"
  checksum node["php-fpm"][:checksum]
  not_if &php_already_installed
end

execute "PHP: unpack" do
  command "cd /tmp && tar -xzf php-#{node["php-fpm"][:version]}.tgz"
  not_if &php_already_installed
end

execute "PHP: ./configure" do
  cwd "/tmp/php-#{node["php-fpm"][:version]}"
  environment "HOME" => "/root"
  command "./configure --prefix=#{node["php-fpm"][:prefix]} --with-openssl --disable-posix --without-sqlite --without-sqlite3 --with-mysqli=mysqlnd --disable-posix --disable-phar --disable-pdo --enable-fpm --with-fpm-user=#{node["php-fpm"][:user]} --with-fpm-group=#{node["php-fpm"][:group]} --with-pear=/usr/local/pear"
  not_if &php_already_installed
end

execute "PHP: make, make install" do
  cwd "/tmp/php-#{node["php-fpm"][:version]}"
  environment "HOME" => "/root"
  command "make && make install"
  not_if &php_already_installed
end

template "/usr/local/lib/php.ini" do
  mode "0755"
  source "php.ini.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "/usr/local/etc/php-fpm.conf" do
  mode "0755"
  source "php-fpm.conf.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "/etc/init.d/php-fpm" do
  mode "0755"
  source "init.d.php-fpm.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

service "php-fpm" do
  service_name "php-fpm"
  supports [:start, :status, :restart]
  action :restart
end

template "/etc/logrotate.d/php" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end

include_recipe "php-fpm::apc"