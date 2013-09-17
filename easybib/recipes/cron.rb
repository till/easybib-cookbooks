cron "Add our email into crontab" do
  mailto node["sysop_email"]

  not_if do
    node["sysop_email"].empty?
  end
end
