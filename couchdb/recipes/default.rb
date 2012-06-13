include_recipe "apt::ppa"
include_recipe "apt::easybib"

package "apache-couchdb"

include_recipe "couchdb::prepare"
include_recipe "couchdb::configure"
