package "php5-cli"

root_dir = "/opt/easybib"

php_bin = "/usr/bin/php"

directory root_dir do
  owner "root"
  group "root"
  action :create
end

git "#{root_dir}/session-trasher" do
  repository "git://github.com/easybib/session-trasher.git"
  reference "master"
  action :sync
end

if !is_aws() || !node[:mysql]
  raise "This relies on the password being send from Custom JSON"
end

mysql_password = node[:mysql][:server_root_password]

# cron starts at 10 AM UTC (~4 AM EST depending on DST)
cron root_dir do
  hour "10"
  minute "0"
  command "#{php_bin} #{root_dir}/session-trasher/script.php -p=#{mysql_password}"
end
