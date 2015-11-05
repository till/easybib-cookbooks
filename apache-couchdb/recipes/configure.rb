require 'net/http'
require 'json'

logrotate_app 'couchdb' do
  cookbook 'logrotate'
  path '/var/log/couchdb/*.log'
  frequency 'daily'
  rotate 2
end

couchdb_config = node['apache-couchdb']['config']

apache_couchdb_config 'instance' do
  config couchdb_config
  host couchdb_config['httpd']['bind_address']
  port couchdb_config['httpd']['port']
  instance ::EasyBib.get_instance(node)
end

include_recipe 'apache-couchdb::monitoring'
