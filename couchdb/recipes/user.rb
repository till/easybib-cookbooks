group "couchdb" do
  gid node["couchdb"]["gid"]
end

user "couchdb" do
  comment "CouchDB"
  home node["couchdb"]["datadir"]
  action :create
  gid node["couchdb"]["gid"]
  shell "/bin/zsh"
end
