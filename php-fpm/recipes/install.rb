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
  command "./configure --with-mysql=mysqlnd --disable-posix --disable-phar --disable-pdo --enable-fpm --with-fpm-user=#{node["php-fpm"][:user]} --with-fpm-group=#{node["php-fpm"][:group]} --with-pear=/usr/local/pear"
  not_if &php_already_installed
end

execute "PHP: make, make install" do
  cwd "/tmp/php-#{node["php-fpm"][:version]}"
  environment "HOME" => "/root"
  command "make && make install"
  not_if &php_already_installed
end

phpini = "/etc/php5/cgi/php.ini"
execute "PHP: post install configuration" do

  # turn on error logging, turn off display of errors
  if node["php-fpm"][:logerrors]
    command %Q{ sed -i "s,log_errors = Off,log_errors = On,g" #{phpini} }
    command %Q{ sed -i "s,;error_log = filename,error_log = #{node["php-fpm"][:logfile]},g" #{phpini} }
  end

  unless node["php-fpm"][:displayerrors]
    command %Q{ sed -i "s,display_errors = On,display_errors = Off,g" #{phpini} }
  end

  # hide PHP
  command %Q{ sed -i "s,expose_php = On,expose_php = Off,g" #{phpini} }

  # realpath cache
  command %Q{ sed -i "s,; realpath_cache_size=16k,realpath_cache_size=128k,g" #{phpini} }
  command %Q{ sed -i "s,; realpath_cache_ttl=120,realpath_cache_ttl=3600,g" #{phpini} }

  # up the memory_limit and max_execution_time
  command %Q{ sed -i "s,memory_limit = 16M,memory_limit = #{node["php-fpm"][:memorylimit]},g" #{phpini} }
  command %Q{ sed -i "s,max_execution_time = 30,max_execution_time = #{node["php-fpm"][:maxexecutiontime]},g" #{phpini} }

  # fix ubuntu fuck ups
  command %Q{ sed -i "s,magic_quotes_gpc = On,magic_quotes_gpc = Off,g" #{phpini} }
end

execute "PHP: install pear packages" do
  command "pear channel-update pear.php.net"
  command "pear install -f Crypt_HMAC2-beta"
  command "pear install -f Net_Gearman-alpha"
  command "pear install -f Services_Amazon_S3-alpha"
end

service "php-fpm" do
  service_name "php-fpm"
  supports [:start, :status, :restart]
  action :restart
end