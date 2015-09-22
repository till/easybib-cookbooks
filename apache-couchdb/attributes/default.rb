default['apache-couchdb'] = {
  'ppa' => 'ppa:couchdb/stable'
}

default['apache-couchdb']['config'] = {
  'httpd' => {
    'port' => 5984,
    'bind_address' => '127.0.0.1'
  },
  'log_level_by_module' => {
    'couch_httpd' => 'warning'
  }
}

default['apache-couchdb']['fauxton'] = {
  'repository' => 'https://github.com/apache/couchdb-fauxton.git',
  'version' => 'b61f60181ccc9d728bde5e6ad7ebbec4a4bd7b20'
}
