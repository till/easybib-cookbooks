default['syslog']                       = {}
default['syslog']['logfiles']           = {
  '/var/log/nginx/error.log' => 'error',
  '/var/log/php/slow.log' => 'notice',
  '/var/log/php/error.log' => 'error',
  '/var/log/php/fpm.log' => 'error',
  '/var/log/supervisor/supervisord.log' => 'error'
}

default['syslog']['host']               = 'logs-01.loggly.com'
default['syslog']['poll']               = 10

default['loggly']['token'] = 'example'
default['loggly']['input']  = 1
default['loggly']['ca_file'] = '/etc/ssl/certs/logs-01.loggly.com_sha12.crt'
