# create this directory to save PID files to of the processes we run
directory "/var/run/citation-backup" do
  mode      "0755"
  owner     "www-data"
  group     "www-data"
  recursive true
end

# symlink start script
link "/srv/www/citationbackup/current/scripts/init.d/redis-importer" do
  to "/etc/init.d/redis-importer"
end
