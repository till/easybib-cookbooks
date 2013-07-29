cron "Add our email into crontab" do
  mailto node["sysop_email"]

  only_if do
    node.attribute?("sysop_email") && !node["sysop_email"].empty?
  end
end
