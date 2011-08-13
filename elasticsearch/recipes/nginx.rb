# assume nginx-app::server was run before

template "/etc/nginx/sites-enabled/elasticsearch.conf" do
  source "nginx-elasticsearch.conf.erb"
  owner  "www-data"
  group  "www-data"
end

service "nginx" do
  action :restart
end
