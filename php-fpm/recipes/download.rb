# download the source and extract it

remote_file "/tmp/php-#{node["php-fpm"][:version]}.tgz" do
  source "http://www.php.net/get/php-#{node["php-fpm"][:version]}.tar.gz/from/www.php.net/mirror"
  checksum node["php-fpm"][:checksum]
end

execute "PHP: unpack" do
  command "cd /tmp && tar -xzf php-#{node["php-fpm"][:version]}.tgz"
end
