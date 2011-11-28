pool_config_dir = "/usr/local/etc/php-fpm"

directory "#{pool_config_dir}" do
  mode      "0755"
  owner     "www-data"
  group     "www-data"
  recursive true
end

node[:users].each do |username,prop|
  template "#{pool_config_dir}/#{username}.conf" do
    source "pool.conf.erb"
    owner  username
    group  username
    mode   0755
    variables(
      :user => username
    )
  end
end
