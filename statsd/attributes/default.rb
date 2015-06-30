default['librato'] = {}

default['librato']['statsd']            = {}
default['librato']['statsd']['etc_dir'] = '/etc/statsd'
default['librato']['statsd']['user']    = 'root'
default['librato']['statsd']['group']   = 'root'
default['librato']['statsd']['port']    = 8125

default['librato']['metrics']            = {}
default['librato']['metrics']['email']   = 'foo@example.org'
default['librato']['metrics']['api_key'] = '123'
default['librato']['metrics']['batch']   = 200

default['statsd'] = {
  'deploy_dir' => '/vagrant/statsd',
  'repository' => 'git://github.com/easybiblabs/statsd.git',
  'branch' => 'deploy',
  'user' => 'www-data',
  'group' => 'www-data'
}
