template "#{php_prefix}/etc/php.ini" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl => "Off"
  )
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "#{php_prefix}/etc/php-cli.ini" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl => "On"
  )
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
