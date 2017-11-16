default['ies-gearmand']['port'] = 31_337
default['ies-gearmand']['log']  = '--syslog -l stderr' # or --logfile=/path/to/whatever
default['ies-gearmand']['name'] = 'gearman'
default['ies-gearmand']['group'] = 'gearman'
default['ies-gearmand']['package_uri'] = 'ppa:ondrej/pkg-gearman'
default['ies-gearmand']['package_distro'] = 'trusty'

# normal['php']['ppa'] = {
#  'name' => 'ondrejphp',
#  'package_prefix' => 'php5.6',
#  'uri' => 'ppa:ondrej/php'
# }