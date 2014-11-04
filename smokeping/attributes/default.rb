default['smokeping'] = {
  'config' => {
    'aws' => {
      'access-key-id' => '',
      'secret-key-id' => ''
    },
    'menu' => {
      'menu' => 'Top',
      'remark' => 'Welcome to smokeping',
      'title' => 'Network Latency Grapher'
    },
    'probes' => [
      {
        'name' => 'FPing',
        'binary' => '/usr/bin/fping',
        'packetsize' => 1000
      },
      {
        'name' => 'DNS',
        'binary' => '/usr/bin/dig',
        'pings' => 5,
        'step' => 180
      },
      {
        'name' => 'Curl',
        'binary' => '/usr/bin/curl',
        'step' => 60,
        'urlformat' => 'http://%host%/'
      }
    ],
    'targets' => []
  }
}

# default['config']['databases'] = [
#  {
#    'host' => 'couchdb.something.com',
#    'menu' => 'couchdb',
#    'probe' => 'Curl',
#    'title' => 'couchdb'
#  },
#  {
#    'host' => 'couchdb.staging.something.com',
#    'menu' => 'couchdb.staging',
#    'probe' => 'Curl',
#    'title' => 'couchdb'
#  }
# ]
