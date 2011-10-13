include_recipe "couchdb::deps"

couchbaseDep = File.basename(node[:couchbase][:dl]);

remote_file "/tmp/#{couchbaseDep}" do
  source "#{node[:couchbase][:dl]}"
end

execute "install couchbase" do
  command "dpkg -i /tmp/#{couchbaseDep}"
end
