default['gearmand']         = {}
default['gearmand']['name'] = 'easybib-gearman'
default['gearmand']['user'] = 'gearman'
default['gearmand']['port'] = 31337
default['gearmand']['log']  = '--syslog' #or --logfile=/path/to/whatever

# these are relevant for when we compile from source
default['gearmand']['prefix']            = '/opt/gearman'
default['gearmand']['source']            = {}
default['gearmand']['source']['version'] = '1.1.9'
default['gearmand']['source']['flags']   = '--disable-libdrizzle --disable-libmemcached --disable-libpq --disable-libtokyocabinet --disable-hiredis'
default['gearmand']['source']['link']    = 'https://launchpad.net/gearmand/1.2/1.1.9/+download/gearmand-1.1.9.tar.gz'
default['gearmand']['source']['hash']    = '149a4a874150e74467f888e43121b7da324ac463fbace0f1ed55ed4a0362ecde'
