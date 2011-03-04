%w{ant subversion htop curl php5-easybib autoconf}.each do |a_package|
  package a_package
end

#should be there because of php5-easybib already, but make sure that it exists, otherwise the pear-exitwrapper installation will fail
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
  command "sudo pear-exitwrapper config-set auto_discover 1"
end

channels = node[:php_pear][:channels]
channels.each do |channel|
  execute "php-pear: discover channel #{channel}" do
    ignore_failure true
    command "sudo pear-exitwrapper channel-discover #{channel}"
    ignore_failure true
	end
end

execute "php-pear: update channel" do
  command "sudo pear-exitwrapper channel-update pear.php.net"
end

#phploc needs newest pear installer
execute "php-pear: updating pear" do
  command "sudo pear upgrade pear"
end

#phpunit needs newest xdebug
execute "php5-xdebug: updating xdebug" do
  command "sudo pecl install xdebug"
end

packages = node[:php_pear][:packages]
packages.each do |package|
  execute "php-pear: install #{package}" do
    command "sudo pear-exitwrapper install #{package}"
    ignore_failure true
	end
end

execute "php-pear: upgrade all packages" do
  command "sudo pear-exitwrapper upgrade-all"
end
