default['ies-mysql'] = {}
default['ies-mysql']['version'] = '5.6'

default['ies-mysql']['server-config'] = {
  'user' => 'root'
  'password' => '',
  'port' => 3306,
  'bind-address' => '0.0.0.0',
  'instance-name' => 'vagrant'
}

default['ies-mysql']['mysqld-config'] = {
  'interactive_timeout' => 300,
  'log-queries-not-using-indexes' => '',
  'log-slow-queries' => '/var/log/mysql/log-slow-queries.log',
  'wait_timeout' => 60,
  'innodb_buffer_pool_size' => '512M',
  'innodb_flush_log_at_trx_commit' => 0,
  'innodb_flush_method' => 'O_DIRECT',
  'skip-name-resolve' => ''
}
