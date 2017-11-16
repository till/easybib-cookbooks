default['php']['ppa']['name'] = 'easybib-ppa'
default['php']['ppa']['uri'] = ::EasyBib::Ppa.ppa_mirror(node)
default['php']['ppa']['package_prefix'] = 'php5-easybib'

default['php']['extensions']['config_dir'] = 'etc/php'
default['php']['extensions']['ini_suffix'] = '-settings'

default['php-aws-elasticache']['settings'] = {}

default['php-apc'] = {}
# custom prefix for package: php-apcu, instead of php5.6-apcu
default['php-apc']['package_prefix'] = nil
default['php-apc']['settings']['ttl'] = 0
default['php-apc']['settings']['mmap_file_mask'] = '/dev/zero'
default['php-apc']['settings']['shm_size'] = '70M'
default['php-apc']['load_priority'] = nil

default['php-gearman'] = {}
default['php-gearman']['package_uri'] = 'ppa:ondrej/php'
default['php-gearman']['package_distro'] = 'trusty'
# needed for above for dependency
default['pkg-gearman'] = {}
default['pkg-gearman']['package_uri'] = 'ppa:ondrej/pkg-gearman'
default['pkg-gearman']['package_distro'] = 'trusty'

default['php-mysqli']['settings']['reconnect'] = 1
default['php-mysqli']['load_priority'] = nil

default['php-tidy']['settings']['clean_output'] = 0
default['php-tidy']['load_priority'] = nil

default['php-soap']['settings']['wsdl_cache_enabled'] = 1
default['php-soap']['settings']['wsdl_cache_ttl'] = 86_400
default['php-soap']['settings']['wsdl_cache_limit'] = 5
default['php-soap']['load_priority'] = nil

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
default['php-opcache']['load_priority'] = nil

default['php-xdebug']['settings'] = {
  'scream'               => 1,
  'show_exception_trace' => 0,
  'remote_enable'        => 1,
  'remote_handler'       => 'dbgp',
  'remote_connect_back'  => 1,
  'idekey'               => 'XDEBUG_PHPSTORM'
}
default['php-xdebug']['load_priority'] = nil

default['php-phar']['settings'] = {
  'detect_unicode' => 'Off',
  'readonly' => 'Off',
  'require_hash' => 'Off'
}
default['php-phar']['load_priority'] = nil

default['amazon-elasticache-cluster-client'] = {
  'php_version' => '7.0'
}

default['php-poppler']['settings'] = {}

default['poppler'] = {}
default['poppler']['package_uri'] = 'https://packagecloud.io/till/poppler-backport/ubuntu/'
default['poppler']['package_distro'] = 'trusty'
default['poppler']['package_components'] = ['main']
default['poppler']['package_key_uri'] = 'packagecloud-poppler.gpg'
default['poppler']['package_list'] = ['poppler', 'poppler-glib', 'php-poppler-pdf']

default['freetds'] = {
  'server_name' => nil,
  'host' => nil,
  'port' => 1433,
  'tds_version' => 8.0,
  'charset' => 'UTF-8'
}
