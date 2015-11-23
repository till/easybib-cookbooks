default['php']['ppa']['package_prefix'] = 'php5-easybib'

default['php-apc'] = {}
default['php-apc']['settings']['ttl'] = 0
default['php-apc']['settings']['mmap_file_mask'] = '/dev/zero'
default['php-apc']['settings']['shm_size'] = '70M'

default['php-mysqli']['settings']['reconnect'] = 1

default['php-opcache']['settings'] = {
  'memory_consumption' => 500,
  'interned_strings_buffer' => 8,
  'max_accelerated_files' => 12_000,
  'validate_timestamps' => 0,
  'save_comments' => 1,
  'fast_shutdown' => 1,
  'enable_file_override' => 0,
  'enable_cli' => 0,
  'optimization_level' => 0,
  'max_wasted_percentage' => 10,
  'error_log' => nil
}
