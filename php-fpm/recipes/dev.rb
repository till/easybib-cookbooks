# this assumes our prefix
pool_config_dir = "#{node["php-fpm"]["prefix"]}/etc/php-fpm"

directory pool_config_dir do
  mode      "0755"
  owner     "www-data"
  group     "www-data"
  recursive true
end

node["users"].each do |username,prop|
  template "#{pool_config_dir}/#{username}.conf" do
    source "pool.conf.erb"
    owner  "www-data"
    group  "www-data"
    mode   "0644"
    variables(
      :user => username
    )
  end
end
