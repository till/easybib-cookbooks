# install a cronjob to run every 5 minutes

if node[:scalarium][:instance][:roles].include?('bibapi')
  cron "stats from redis to mysql" do
    mailto node[:sysop_email]
    minute "*/5"
    command "/srv/www/easybib_api/current/app/modules/default/scripts/cron_tracking_into_mysql.php"
  end
end
