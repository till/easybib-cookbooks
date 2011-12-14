include_recipe "percona::xtrabackup"

# install scripts required for daily backup

# compress the backup
template "/usr/bin/easybib-backthisup" do
  source "backthisup.sh.rb"
  mod    "0755"
end

# script to store backups in s3
template "/usr/bin/easybib-s3upload" do
  source "s3upload.sh.erb"
  mode   "0755"
end
