include_recipe "couchdb::user"
include_recipe "couchdb::deps"
include_recipe "couchdb::prepare"

couchdb_version = node["couchdb"]["version"]

guess_version = Mixlib::ShellOut.new("which couchdb > /dev/null && couchdb -V | grep #{couchdb_version}")
guess_version.run_command
guess_version.error!

couchdb_installed_version = guess_version.stdout.strip.gsub(/^.+([0-9.]{5,5})$/, '\1')

couchdb_already_installed = lambda do
  couchdb_installed_version == couchdb_version
end

remote_file "#{Chef::Config[:file_cache_path]}/apache-couchdb-#{couchdb_version}.tgz" do
  source "http://apache.easy-webs.de/couchdb/#{couchdb_version}/apache-couchdb-#{couchdb_version}.tar.gz"
  not_if &couchdb_already_installed
end

execute "unpack CouchDB" do
  command "tar -xzf apache-couchdb-#{couchdb_version}.tgz"
  not_if &couchdb_already_installed
  cwd Chef::Config[:file_cache_path]
end

execute "Configure CouchDB" do
  cwd "#{Chef::Config[:file_cache_path]}/apache-couchdb-#{couchdb_version}"
  environment "HOME" => "/root"
  command "./configure --sysconfdir=/etc"
  not_if &couchdb_already_installed
end

execute "Compile and install CouchDB" do
  cwd "#{Chef::Config[:file_cache_path]}/apache-couchdb-#{couchdb_version}"
  environment "HOME" => "/root"
  command "make && make install"
  not_if &couchdb_already_installed
end

include_recipe "couchdb::configure"

execute "Running on port 80, we require root" do
  command "sed -i 's,COUCHDB_USER=couchdb,COUCHDB_USER=root,g' /etc/default/couchdb"
  only_if do
    node["couchdb"]["port"] == 80
  end
end

include_recipe "couchdb::service"

template "/etc/logrotate.d/couchdb" do
  source "logrotate.erb"
  mode "0644"
  owner "root"
  group "root"
end

include_recipe "couchdb::backup"
