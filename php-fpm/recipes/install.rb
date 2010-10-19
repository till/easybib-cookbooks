include_recipe "php-fpm::prepare"

php_installed_version = `which php >> /dev/null && php -v|grep #{node["php-fpm"][:version]}|awk '{ print substr($2,1,5) }'`

php_prefix = node["php-fpm"][:prefix]

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

  php_opts = []
  php_opts << "--with-config-file-path=#{php_prefix}/etc"
  php_opts << "--with-config-file-scan-dir=#{php_prefix}/etc/php"
  php_opts << "--prefix=#{php_prefix}"
  php_opts << "--with-pear=#{php_prefix}/pear"

  php_exts = []
  php_exts << "--enable-sockets"
  php_exts << "--enable-soap"
  php_exts << "--with-openssl"
  php_exts << "--disable-posix"
  php_exts << "--without-sqlite"
  php_exts << "--without-sqlite3"
  php_exts << "--with-mysqli=mysqlnd"
  php_exts << "--disable-posix"
  php_exts << "--disable-phar"
  php_exts << "--disable-pdo"
  php_exts << "--enable-pcntl"
  php_exts << "--with-curl"
  php_exts << "--with-tidy"

  php_fpm = []
  php_fpm << "--enable-fpm"
  php_fpm << "--with-fpm-user=#{node["php-fpm"][:user]}"
  php_fpm << "--with-fpm-group=#{node["php-fpm"][:group]}"

  cwd "/tmp/php-#{node["php-fpm"][:version]}"
  environment "HOME" => "/root"

  command "./configure #{php_opts.join(' ')} #{php_exts.join(' ')} #{php_fpm.join(' ')}"

  not_if &php_already_installed
end

# run with make -j4 cause we have 4 ec2 compute units
execute "PHP: make, make install" do
  cwd "/tmp/php-#{node["php-fpm"][:version]}"
  environment "HOME" => "/root"
  command "make -j4 && make install"
  not_if &php_already_installed
end

template "#{php_prefix}/etc/php.ini" do
  mode "0755"
  source "php.ini.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "#{php_prefix}/etc/php-cli.ini" do
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

directory "#{php_prefix}/etc/php" do
  owner "root"
  group "root"
  mode "0755"
  action :create
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
include_recipe "php-fpm::xhprof"
