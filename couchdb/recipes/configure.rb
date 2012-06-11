template "/etc/couchdb/local.d/scalarium.ini" do
  source "scalarium.ini.erb"
  owner "couchdb"
  group "couchdb"
  mode "0644"
end
