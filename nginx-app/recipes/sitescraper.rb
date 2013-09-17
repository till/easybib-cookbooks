if is_aws()
  deploy_dir = "/srv/www/sitescraper/current/www"
  nginx_extras = ""
else
  deploy_dir = "/vagrant_data/www"
  nginx_extras = "sendfile off;"
end

template "/etc/nginx/sites-enabled/sitescraper.conf" do
  source "sitescraper.conf.erb"
  mode   "0755"
  owner  node["nginx-app"]["user"]
  group  node["nginx-app"]["group"]
  variables(
    :php_upstream   => "unix:/var/run/php-fpm/#{node["php-fpm"]["user"]}",
    :doc_root       => deploy_dir,
    :access_log     => 'off',
    :nginx_conf     => node["nginx-app"][:config_dir],
    :nginx_extra    => nginx_extras,
    :routes_enabled => node["nginx-app"]["sitescraper"]["routes_enabled"],
    :routes_denied  => node["nginx-app"]["sitescraper"]["routes_denied"]
  )
  notifies :restart, "service[nginx]", :delayed
end
