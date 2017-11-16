default['ies-gearmand']['port'] = 31_337
default['ies-gearmand']['log']  = '--syslog -l stderr' # or --logfile=/path/to/whatever
default['ies-gearmand']['name'] = 'gearman'
default['ies-gearmand']['group'] = 'gearman'

normal['php']['ppa'] = {
 'name' => 'ondrejgearman',
 'package_prefix' => '',
 'uri' => 'ppa:ondrej/pkg-gearman'
}
