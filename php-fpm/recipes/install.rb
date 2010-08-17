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
  command "./configure --enable-fpm --with-fpm-user=#{node["php-fpm"][:user]} --with-fpm-group=#{node["php-fpm"][:group]} --with-pear=/usr/local/pear"
  not_if &php_already_installed
end

execute "PHP: make && make install" do
  cwd "/tmp/php-#{node["php-fpm][:version]}"
  environment "HOME" => "/root"
  command "make && make install"
  not_if &php_already_installed
end

execute "PHP: post install configuration" do
  # turn on error logging, turn off display of errors

  if node["php-fpm"][:logerrors]
    command "sed -i "s,log_errors = Off,log_errors = On,g" /etc/php5/cgi/php.ini"
    command "sed -i "s,;error_log = filename,error_log = #{node["php-fpm"][:logfile]},g" $php_ini"
  end

  unless node["php-fpm"][:displayerrors]
    command "sed -i "s,display_errors = On,display_errors = Off,g" $php_ini"
  end

  # hide PHP
  command "sed -i "s,expose_php = On,expose_php = Off,g" $php_ini"

  # realpath cache
  command "sed -i "s,; realpath_cache_size=16k,realpath_cache_size=128k,g" $php_ini"
  command "sed -i "s,; realpath_cache_ttl=120,realpath_cache_ttl=3600,g" $php_ini"

  # up the memory_limit and max_execution_time
  command "sed -i "s,memory_limit = 16M,memory_limit = #{node["php-fpm"][:memorylimit]},g" $php_ini"
  command "sed -i "s,max_execution_time = 30,max_execution_time = 60,g" $php_ini"

  # fix ubuntu fuck ups
  command "sed -i "s,magic_quotes_gpc = On,magic_quotes_gpc = Off,g" $php_ini"
end

execute "PHP: install pear packages" do
  command "pear channel-update pear.php.net"
  command "pear install -f Crypt_HMAC2-beta"
  command "pear install -f Net_Gearman-alpha"
end

service "php-fpm" do
  service_name "php-fpm"
  supports [:start, :status, :restart]
  action :start
  not_if "which couchdb > /dev/null && couchdb -s"
end