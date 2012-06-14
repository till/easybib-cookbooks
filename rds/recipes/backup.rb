package "python-argparse"
package "mysql-client-5.1"

template "/usr/local/bin/rdsbackup.sh" do
  source "rdsbackup.sh.erb"
  mode "0755"
end

cookbook_file "/usr/local/bin/s3uploadfix.sh" do
  source "s3uploadfix.sh"
  mode "0755"
end

#cron "rdsbackup" do
#  hour "*"
#  minute "9"
#  command "/usr/local/bin/rdsbackup.sh"
#end
