if node[:xdebug][:version] == 'latest'
  xdebug_version = ""
else
  xdebug_version = "-#{node[:xdebug][:version]}"
end

execute "install xdebug" do
  command "pecl install xdebug#{xdebug_version}"
end

include_recipe "php-xdebug::configure"
