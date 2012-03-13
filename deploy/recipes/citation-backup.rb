# create this directory to save PID files to of the processes we run
directory "/var/run/citation-backup" do
  mode      "0755"
  owner     "www-data"
  group     "www-data"
  recursive true
end

# symlink start script
link "/etc/init.d/redis-importer" do
  to "/srv/www/citationbackup/current/scripts/init.d/redis-importer"
end

# symlink into a sane location
link "/usr/local/bin/redis-backup" do
  to "/srv/www/citationbackup/current/scripts/backup.php"
end

cron "run backup to s3" do
  minute  "*/5"
  command "/usr/local/bin/php /usr/local/bin/redis-backup -e production -b"
end
