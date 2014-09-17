default['syslog']                       = {}
default['syslog']['logfiles']           = {
  '/var/log/nginx/error.log' => 'error',
  '/var/log/php/slow.log' => 'notice',
  '/var/log/php/error.log' => 'error',
  '/var/log/php/fpm.log' => 'error'
}

default['syslog']['host']               = 'logs-01.loggly.com'
default['syslog']['poll']               = 10

set_unless['loggly']['token'] = 'example'
set_unless['loggly']['input']  = 1
