normal['elasticsearch']['version']  = '1.2.2'

default['packetbeat'] = {
  'agent_deb' => 'https://github.com/packetbeat/packetbeat/releases/download/v0.3.3/packetbeat_0.3.3-1_amd64.deb',
  'dashboards' => ['MySQL+Performance', 'Packetbeat+Search', 'Packetbeat+Statistics', 'PgSQL+Performance'],
  'config' => {
    'elasticsearch' => 'http://127.0.0.1:9200',
    'ignore_outgoing' => true,
    'protocols' => {
      'http' => [80, 8080, 8000, 5000, 8002],
      'mysql' => [3306],
      'pgsql' => [5432],
      'redis' => [6379]
    },
    'procs' => {
      'mysqld' => 'mysqld',
      'pgsql' => 'postgres',
      'nginx' => 'nginx',
      'php' => 'php-fpm'
    },
    'hide_keywords' => ['pass=', 'password=', 'passwd=', 'Password=']
  }
}
