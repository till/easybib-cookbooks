if node["couchdb"]["backup"]
  template "/usr/local/bin/couchdb_backup" do
    source "couchdb_backup.erb"
    mode "0755"
    owner "root"
    group "root"
  end

  template "/usr/local/bin/couchdb_clean_backups" do
    source "couchdb_clean_backups.erb"
    mode "0755"
    owner "root"
    group "root"
  end

  directory node["couchdb"]["backupdir"] do
    mode "0755"
    owner "root"
    owner "root"
    recursive true
  end

  execute "set owner on couchdb backup directory" do
    command "chown -R couchdb:couchdb #{node["couchdb"]["backupdir"]}"
  end

  cron "backup couchdb files" do
    hour "0-23/4"
    minute "0"
    command "/usr/local/bin/couchdb_backup"
    user "couchdb"
    path "/usr/bin:/usr/local/bin:/bin:/sbin:/usr/sbin"
  end
end
