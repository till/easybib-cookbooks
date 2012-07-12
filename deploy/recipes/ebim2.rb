cron "run collect stats every hour" do
  minute  "23"
  user "www-data"
  command "/usr/local/bin/php /srv/www/ebim2/current/bin/ebim2 cron-collect-stats >> /var/log/ebim-stats.log 2>&1"
end