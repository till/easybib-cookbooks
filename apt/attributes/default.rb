default["apt"] = {}
default["apt"]["upgrade-package"] = nil

default['apt']['cacher-client']['restrict_environment'] = false
default['apt']['cacher_dir'] = '/var/cache/apt-cacher-ng'
default['apt']['cacher_interface'] = nil
default['apt']['cacher_port'] = 3142
default['apt']['caching_server'] = false
default['apt']['compiletime'] = false
default['apt']['key_proxy'] = ''
default['apt']['cache_bypass'] = {}
default['apt']['periodic_update_min_delay'] = 86_400
