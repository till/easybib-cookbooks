default['smokeping']['menu'] = {
  'menu' => 'Top',
  'remark' => 'Welcome to smokeping',
  'title' => 'Network Latency Grapher'
}

default['smokeping']['pathnames']['sendmail'] = '/usr/sbin/sendmail'
default['smokeping']['pathnames']['imgurl'] = '../smokeping/images'
default['smokeping']['pathnames']['smokemail'] = '/etc/smokeping/smokemail'
default['smokeping']['pathnames']['tmail'] = '/etc/smokeping/tmail'

default['smokeping']['directories']['imgcache'] = '/var/cache/smokeping/images'
default['smokeping']['directories']['datadir'] = '/var/lib/smokeping'
default['smokeping']['directories']['piddir'] = '/var/run/smokeping'

default['smokeping']['targets'] = {}

default['smokeping']['probes']['FPing'] = {
  'binary' => '/usr/bin/fping',
  'packetsize' => 1000
}
default['smokeping']['probes']['DNS'] = {
  'binary' => '/usr/bin/dig',
  'pings' => 5,
  'step' => 180
}
default['smokeping']['probes']['Curl'] = {
  'binary' => '/usr/bin/curl',
  'step' => 60,
  'urlformat' => 'http://%host%/'
}
