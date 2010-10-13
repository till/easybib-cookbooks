template "/etc/rsyslog.d/10-loggly.conf" do
  source "10-loggly.conf.erb"
  mode "0644"
end
