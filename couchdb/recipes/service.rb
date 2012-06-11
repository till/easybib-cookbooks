template "/etc/init.d/couchdb" do
  source "init.erb"
  mode   "0755"
end

service "couchdb" do
  service_name "couchdb"
  supports [:start, :status, :restart]
  action :start
  not_if "which couchdb > /dev/null && couchdb -s"
end
