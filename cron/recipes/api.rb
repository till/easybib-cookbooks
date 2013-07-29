# install a cronjob to run every 5 minutes

roles = get_instance_roles()

cron "stats from redis to mysql" do
  mailto node[:sysop_email]
  minute "*/5"
  command "/usr/local/bin/php /srv/www/easybib_api/current/app/modules/default/scripts/cron_tracking_into_mysql.php"
  only_if do
    roles.include?('bibapi')
  end
end
