if node["sysop_email"] then
  cron "Add our email into crontab" do
    mailto "#{node["sysop_email"]}"
  end
end