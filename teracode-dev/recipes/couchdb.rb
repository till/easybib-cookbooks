template "/etc/nginx/sites-enabled/couchdb.conf" do
  source "couchdb.conf.erb"
  mode "0644"
  owner "www-data"
  group "www-data"
end
