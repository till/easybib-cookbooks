default['ies-letsencrypt'] = {
  :domains => [],
  :certbot => {
    :bin => '/usr/local/bin/certbot-auto',
    :port => 54_321,
    :download => 'https://dl.eff.org/certbot-auto'
  }
}
