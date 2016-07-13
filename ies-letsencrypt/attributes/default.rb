default['ies-letsencrypt'] = {
  :domains => [],
  :certbot => {
    :bin => '/usr/local/bin/certbot-auto',
    :cron => '/usr/local/bin/certbot-cronjob',
    :etc => '/etc/letsencrypt',
    :port => 54_321,
    :download => 'https://dl.eff.org/certbot-auto'
  }
}
