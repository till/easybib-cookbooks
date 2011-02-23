%w{ant subversion htop curl php5-xdebug php5-cli php-pear}.each do |a_package|
  package a_package
end

execute "php-pear: auto discover for channels" do
  command "sudo pear config-set auto_discover 1"
end

channels = node[:php_pear][:channels]
channels.each do |channel|
  execute "php-pear: discover channel #{channel}" do
    ignore_failure true
    command "sudo pear channel-discover #{channel}"
    ignore_failure true
	end
end

execute "php-pear: update channel" do
  command "sudo pear channel-update pear.php.net"
end

packages = node[:php_pear][:packages]
packages.each do |package|
  execute "php-pear: install #{package}" do
    command "sudo pear install #{package}"
    ignore_failure true
	end
end

execute "php-pear: upgrade all packages" do
  command "sudo pear upgrade-all"
end
