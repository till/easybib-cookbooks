include_recipe "php-fpm::prepare"

php_installed_version = `which php >> /dev/null && php -v|grep #{node["php-fpm"][:version]}|awk '{ print substr($2,1,5) }'`

php_already_installed = lambda do
  php_installed_version == node["php-fpm"][:version]
end

include_recipe "php-fpm::download"

execute "PHP: ./configure" do

  php_opts = []
  php_opts << "--with-config-file-path=#{node["php-fpm"][:prefix]}/etc"
  php_opts << "--with-config-file-scan-dir=#{node["php-fpm"][:prefix]}/etc/php"
  php_opts << "--prefix=#{node["php-fpm"][:prefix]}"
  php_opts << "--with-pear=#{node["php-fpm"][:prefix]}/pear"

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

include_recipe "php-fpm::configure"
include_recipe "php-fpm::apc"
include_recipe "php-fpm::xhprof"
