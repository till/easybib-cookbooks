# create this directory to save PID files to of the processes we run
directory "/var/run/citation-backup" do
  mode      "0755"
  owner     "www-data"
  group     "www-data"
  recursive :true
end
