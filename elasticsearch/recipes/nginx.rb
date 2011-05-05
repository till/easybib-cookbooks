# assume nginx-app was run before

template "/etc/nginx/sites-enabled/elasticsearch.conf" do
  source "elasticsearch.conf.erb"
end
