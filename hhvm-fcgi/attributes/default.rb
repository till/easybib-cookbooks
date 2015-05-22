default['hhvm-fcgi'] = {}

default['hhvm-fcgi']['build'] = '' # -nightly, -dbg

if ::EasyBib::Ppa.use_aptly_mirror?(node)
  default['hhvm-fcgi']['apt']['repo'] = 'http://ppa.ezbib.com/trusty55'
else
  default['hhvm-fcgi']['apt'] = {
    'repo' => 'http://dl.hhvm.com/ubuntu',
    'key' => 'http://dl.hhvm.com/conf/hhvm.gpg.key'
  }
end

default['hhvm-fcgi']['boost'] = {
  'ppa' => 'ppa:mapnik/boost'
}

default['hhvm-fcgi']['prefix'] = ''

default['hhvm-fcgi']['tmpdir'] = '/tmp/hhvm'
default['hhvm-fcgi']['logfile'] = '/var/log/hhvm/error.log'

default['hhvm-fcgi']['pid_file'] = '/var/run/hhvm/pid'
default['hhvm-fcgi']['service_name'] = 'hhvm'

default['hhvm-fcgi']['user'] = 'www-data'
default['hhvm-fcgi']['group'] = 'www-data'

default['hhvm-fcgi']['listen'] = {
  'ip' => '127.0.0.1',
  'port' => '9000'
}

default['hhvm-fcgi']['config'] = {}

default['hhvm-fcgi']['config']['hhvm'] = {
  'file' => '/etc/hhvm/config.hdf',
  'display_errors' => 'On'
}

default['hhvm-fcgi']['config']['fcgi'] = {
  'file' => '/etc/hhvm/php-fcgi.ini',
  'hhvm' => true,
  'enable_dl' => 'Off',
  'display_errors' => 'Off',
  'memory_limit' => '512M',
  'max_execution_time' => 60
}

default['hhvm-fcgi']['config']['cli'] = {
  'file' => '/etc/hhvm/php.ini',
  'hhvm' => false,
  'enable_dl' => 'On',
  'display_errors' => 'On',
  'memory_limit' => '1G',
  'max_execution_time' => '-1'
}
