package "ntpdate"

# setup /etc/ntp.conf with more servers
remote_file "/etc/ntp.conf" do
  source "ntp.conf"
  mode 0755
  owner "root"
  group "root"
end

# let cron execute ntpdate once a day
remote_file "/etc/cron.daily/ntpdate" do
  source "ntpdate"
  mode 0755
  owner "root"
  group "root"
end