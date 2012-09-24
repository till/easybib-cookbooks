template "/etc/default/php-fpm" do
  source "default.erb"
  mode   "0644"
end

template "/etc/init.d/php-fpm" do
  mode   "0755"
  source "init.d.php-fpm.erb"
  owner  node["php-fpm"][:user]
  group  node["php-fpm"][:group]
end

service "php-fpm" do
  service_name "php-fpm"
  supports     [:start, :status, :restart]
end
