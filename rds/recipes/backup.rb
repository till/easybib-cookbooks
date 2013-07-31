package "python-argparse"
package "mysql-client-5.1"

cookbook_file "/usr/local/bin/rdsbackup.sh" do
  source "rdsbackup.sh"
  mode "0755"
end

cookbook_file "/usr/local/bin/s3uploadfix.sh" do
  source "s3uploadfix.sh"
  mode "0755"
end

node["rdsbackup"].each do |p|
  jobname = p["jobname"]
  prefix = p["prefix"]
  sqlhost = p["sqlhost"]
  sqluser = p["sqluser"]
  sqlpass = p["sqlpass"]
  s3bucket = p["s3bucket"]
  s3accesskeyid = p["s3accesskeyid"]
  s3secretaccesskey = p["s3secretaccesskey"]
  cronminute = p["cronminute"]
  cronhour = p["cronhour"]
  cronweekday = p["cronweekday"]

  cron_command = sprintf(
    "/usr/local/bin/rdsbackup.sh '%s' '%s' '%s' '%s' '%s' '%s' '%s'",
    sqlhost, sqluser, sqlpass, s3bucket, s3accesskeyid, s3secretaccesskey, prefix
  )

  cron jobname do
    minute cronminute
    hour cronhour
    weekday cronweekday
    command cron_command
  end
end
