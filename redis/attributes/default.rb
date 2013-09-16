default["redis"]                  = {}
default["redis"]["bind_address"]  = '0.0.0.0'
default["redis"]["port"]          = 6379
default["redis"]["timeout"]       = 300
default["redis"]["version"]       = '2.4.0'
default["redis"]["prefix"]        = '/usr/local'
default["redis"]["user"]          = 'redis'
default["redis"]["datadir"]       = '/var/lib/redis'
default["redis"]["log_level"]     = 'notice'
default["redis"]["log_file"]      = '/var/log/redis/redis.log'
default["redis"]["pid_file"]      = '/var/run/redis.pid'
default["redis"]["appendonly"]    = 'no'
default["redis"]["aofile"]        = 'appendonly.aof'
default["redis"]["appendfsync"]   = 'no'

default["redis"]["ppa"] = 'ppa:chris-lea/redis-server'

# master-slave configuration, allow overriding from opsworks/upstream
set_unless["redis"]["master"]             = {}
set_unless["redis"]["master"]["address"]  = 'darth-vader'
set_unless["redis"]["master"]["port"]     = 6379
set_unless["redis"]["master"]["password"] = 'foobar'
set_unless["redis"]["is_slave"]           = false
