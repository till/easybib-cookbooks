include_recipe "percona::xtrabackup"

# install scripts required for daily backup

# tar & compress the backup
template node[:xtrabacku][:processor] do
  source "backthisup.sh.erb"
  mode   "0755"
end

# script to store backups in s3
template node[:xtrabackup][:uploader] do
  source "s3upload.sh.erb"
  mode   "0755"
end
