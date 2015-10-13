default['apache-couchdb'] = {
  'ppa' => 'ppa:couchdb/stable'
}

default['apache-couchdb']['config'] = {
  'couchdb' => {
    'database_dir' => '/var/lib/couchdb',
    'view_index_dir' => '/var/lib/couchdb'
  },
  'couch_httpd_auth' => {
    'require_valid_user' => false
  },
  'httpd' => {
    'port' => 5984,
    'bind_address' => '127.0.0.1'
  },
  'log_level_by_module' => {
    'couch_httpd' => 'warning'
  },
  'daemons' => {
    'compaction_daemon' => '{couch_compaction_daemon, start_link, []}'
  },
  'compactions' => {
    '_default' => '[{db_fragmentation, "70%"}, {view_fragmentation, "60%"}, {from, "07:00"}, {to, "11:00"}]'
  },
  'admins' => {
    'monitoring' => ''
  }
}

default['apache-couchdb']['fauxton'] = {
  'repository' => 'https://github.com/apache/couchdb-fauxton.git',
  'version' => 'b61f60181ccc9d728bde5e6ad7ebbec4a4bd7b20'
}
