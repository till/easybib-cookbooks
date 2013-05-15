owner = "vagrant"

package "mysql-client"

directory node["xhprof.io"]["root"] do
  owner owner
  group owner
  mode 0755
  recursive true
  action :create
end

git node["xhprof.io"]["root"] do
  repository "git://github.com/gajus/xhprof.io.git"
  reference "f1a3ad5b975e09c7e89e9753061679aa12b7b4f6"
  action :sync
end

template "#{node["xhprof.io"]["root"]}/xhprof/includes/config.inc.php" do
  owner owner
  group owner
  mode 0644
  source "config.inc.php.erb"
  variables(
    :url => node["xhprof.io"]["url"],
    :dsn => node["xhprof.io"]["dsn"],
    :username => node["xhprof.io"]["username"],
    :password => node["xhprof.io"]["password"]
  )
end

execute "create database" do
  command "mysql -h #{node["xhprof.io"]["host"]} -u #{node["xhprof.io"]["username"]} -e \"create database if not exists #{node["xhprof.io"]["dbname"]}\""
end

execute "import schema" do
  command "mysql -h #{node["xhprof.io"]["host"]} -u #{node["xhprof.io"]["username"]} #{node["xhprof.io"]["dbname"]} < setup/database.sql"
  cwd node["xhprof.io"]["root"]
end
