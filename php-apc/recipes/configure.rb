include_recipe "php-fpm::service"

is_cloud = is_aws()

template "#{node["php-fpm"]["prefix"]}/etc/php/apc.ini" do
  source "apc.ini.erb"
  mode   "0644"
  variables({
    :is_cloud      => is_cloud,
    :stat          => node["php-apc"]["stat"],
    :slam_defense  => node["php-apc"]["slam_defense"],
    :shm_size      => node["php-apc"]["shm_size"],
    :max_file_size => node["php-apc"]["max_file_size"]
  })
  notifies :reload, "service[php-fpm]", :delayed
end
