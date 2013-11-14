directory node["couchdb"]["datadir"] do
  owner "couchdb"
  group "couchdb"
  mode "0755"
  action :create
  recursive true
  only_if do
    !File.exists?(node["couchdb"]["datadir"])
  end
end

directory node["couchdb"]["viewdir"] do
  owner "couchdb"
  group "couchdb"
  mode "0755"
  action :create
  recursive true
  only_if do
    !File.exists?(node["couchdb"]["viewdir"])
  end
end

%w{db views}.each do |dir|
  directory "#{node["couchdb"]["datadir"]}/#{dir}" do
    owner "couchdb"
    group "couchdb"
    mode "0755"
    action :create
    recursive true
    only_if do
      !File.exists?("#{node["couchdb"]["datadir"]}/#{dir}")
    end
  end
end

directory node["couchdb"]["logdir"] do
  owner "couchdb"
  group "couchdb"
  mode "0755"
  action :create
  recursive true
  only_if do
    !File.exists?(node["couchdb"]["logdir"])
  end
end

execute "ensure correct permissions on CouchDB data" do
  command "chown -R couchdb:couchdb #{node["couchdb"]["datadir"]}"
end
