default['librato'] = {}

default['librato']['statsd']            = {}
default['librato']['statsd']['etc_dir'] = '/etc/statsd'
default['librato']['statsd']['port']    = 8125

default['librato']['metrics']            = {}
default['librato']['metrics']['email']   = 'foo@example.org'
default['librato']['metrics']['api_key'] = '123'
default['librato']['metrics']['batch']   = 200

default['statsd'] = {
  'deploy_dir' => '/opt/statsd',
  'repository' => 'git://github.com/easybiblabs/statsd.git',
  'branch' => 'deploy',
  'user' => '_statsd',
  'group' => '_statsd',
  'version' => '0.7.2-8',
  'repo' => {
    'package_cloud_user' => 'till',
    'package_cloud_repo' => 'ies-statsd'
  }
}
