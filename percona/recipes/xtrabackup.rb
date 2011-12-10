package "xtrabackup"

mysql_password = node[:mysql][:server_root_password]

backup_cmd = `ls /usr/bin/|grep innobackup`.strip

if !backup_cmd.empty?

  directory node[:xtrabackup][:dir] do
    mode  "0744"
    owner "root"
  end

  backup_cmd += " --defaults-file=/etc/mysql/my.cnf --user=root --password=#{mysql_password} #{node[:xtrabackup][:dir]}"
  backup_cmd  = "/usr/bin/#{backup_cmd}"

  cron "add xtrabackup to crontab" do
    mailto  node[:sysop_email]
    weekday node[:xtrabackup][:weekday]
    hour    node[:xtrabackup][:hour]
    minute  node[:xtrabackup][:minute]
    command backup_cmd
  end

end
