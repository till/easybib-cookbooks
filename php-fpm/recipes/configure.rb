stdInstall = [ "source", "easybib" ]
if stdInstall.include?(node["php-fpm"][:source])
  etc_cli_dir = "#{node["php-fpm"][:prefix]}/etc"
  etc_fpm_dir = "#{node["php-fpm"][:prefix]}/etc"
  conf_cli = "php-cli.ini"
  conf_fpm = "php.ini"
else
  if node["php-fpm"][:source] == "ubuntu" 
    etc_cli_dir = "/etc/php5/cli"
    etc_fpm_dir = "/etc/php5/fpm"
    conf_cli = "php.ini"
    conf_fpm = "php.ini"
  else 
    Chef::Log.error("Unknown source: #{node["php-fpm"][:source]}. Bailed.")
    return
  end
end

template "#{etc_fpm_dir}/#{conf_fpm}" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl => "Off"
  )
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "#{etc_cli_dir}/#{conf_cli}" do
  mode "0755"
  source "php.ini.erb"
  variables(
    :enable_dl => "On"
  )
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

template "#{etc_fpm_dir}/php-fpm.conf" do
  mode "0755"
  source "php-fpm.conf.erb"
  owner node["php-fpm"][:user]
  group node["php-fpm"][:group]
end

if node["php-fpm"][:source] == "source"
  directory "#{node["php-fpm"][:prefix]}/etc/php" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
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
