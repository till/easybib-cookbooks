include_recipe "percona::repository"

package "xtrabackup"

mysql_password = node[:mysql][:server_root_password]

backup_cmd = "/usr/bin/xtrabackup"

if File.exists?(backup_cmd)

  directory node[:xtrabackup][:dir] do
    mode  "0744"
    owner "root"
  end

  backup_cmd += " --defaults-file=/etc/mysql/my.cnf --user=root"
  backup_cmd += " --password=#{mysql_password}" unless node[:mysql][:server_root_password].empty?
  backup_cmd += " #{node[:xtrabackup][:dir]}"

  cron "add xtrabackup to crontab" do
    mailto  node[:sysop_email]
    weekday node[:xtrabackup][:weekday]
    hour    node[:xtrabackup][:hour]
    minute  node[:xtrabackup][:minute]
    command backup_cmd
  end

end
