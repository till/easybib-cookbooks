owner = node["xhprof.io"]["owner"]

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

xhprof_dsn = get_dsn()

template "#{node["xhprof.io"]["root"]}/xhprof/includes/config.inc.php" do
  owner owner
  group owner
  mode 0644
  source "config.inc.php.erb"
  variables(
    :url => node["xhprof.io"]["url"],
    :dsn => xhprof_dsn,
    :username => node["xhprof.io"]["username"],
    :password => node["xhprof.io"]["password"]
  )
end

mysql_command = "mysql -h #{node["xhprof.io"]["host"]} -u #{node["xhprof.io"]["username"]}"
if !node["xhprof.io"]["password"].empty?
  mysql_command = "#{mysql_command} -p#{node["xhprof.io"]["password"]}"
end

execute "create database" do
  command "#{mysql_command} -e \"CREATE DATABASE IF NOT EXISTS #{node["xhprof.io"]["dbname"]}\""
end

execute "import schema" do
  command "#{mysql_command} #{node["xhprof.io"]["dbname"]} < setup/database.sql"
  cwd node["xhprof.io"]["root"]
  not_if "#{mysql_command} -e 'SHOW FIELDS FROM `#{node["xhprof.io"]["dbname"]}`.`calls`'"
end

remote_file "#{node["xhprof.io"]["root"]}/composer.phar" do
  source "http://getcomposer.org/composer.phar"
  mode "0755"
end

execute "generate autoload" do
  command "./composer.phar install"
  cwd node["xhprof.io"]["root"]
end
