default['apache-couchdb'] = {
  'ppa' => 'ppa:couchdb/stable'
}

default['apache-couchdb']['config'] = {
  'httpd' => {
    'port' => 5984,
    'bind_address' => '127.0.0.1'
  }
}
