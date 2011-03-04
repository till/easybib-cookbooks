%w{ant subversion htop curl php5-easybib autoconf}.each do |a_package|
  package a_package
end

#should be there because of php5-easybib already, but make sure that it exists, otherwise the pear-exitwrapper pear installation will fail
directory "/usr/local/bin/" do
  action :create
  recursive true
end

cookbook_file "/usr/local/bin/pear-exitwrapper" do
  source "pear-exitwrapper.sh"
  mode "0755"
  owner "root"
  group "root"
end

execute "php-pear: auto discover for channels" do
  command "sudo pear-exitwrapper pear config-set auto_discover 1"
end

channels = node[:php_pear][:channels]
channels.each do |channel|
  execute "php-pear: discover channel #{channel}" do
    ignore_failure true
    command "sudo pear-exitwrapper pear channel-discover #{channel}"
    ignore_failure true
	end
end

execute "php-pear: update channel" do
  command "sudo pear-exitwrapper pear channel-update pear.php.net"
end

#phploc needs newest pear installer
execute "php-pear: updating pear" do
  command "sudo pear-exitwrapper pear upgrade pear"
end

#phpunit needs newest xdebug
execute "php5-xdebug: updating xdebug" do
  command "sudo pear-exitwrapper pecl install xdebug"
end
directory "/usr/local/etc/php" do
  action :create
  owner "www-data"
  recursive true
end

execute "php5-xdebug: adding xdebug to php" do
  command "php -r \"echo 'zend_extension = '.ini_get('extension_dir').'/xdebug.so';\" > /tmp/xdebug.ini && sudo mv /tmp/xdebug.ini /usr/local/etc/php/"
end

packages = node[:php_pear][:packages]
packages.each do |package|
  execute "php-pear: install #{package}" do
    command "sudo pear-exitwrapper pear install #{package}"
    ignore_failure true
	end
end

execute "php-pear: upgrade all packages" do
  command "sudo pear-exitwrapper pear upgrade-all"
end
