default[:apache_solr]            = {}
default[:apache_solr][:version]  = "3.5.0"
default[:apache_solr][:user]     = "root"
default[:apache_solr][:group]    = "root"
default[:apache_solr][:base_dir] = "/opt/apache"
default[:apache_solr][:log_file] = "/var/log/apache-solr.log"

set_unless[:apache_solr][:mirror] = "http://apache.imsam.info/lucene/solr"
set_unless[:apache_solr][:app]    = "easybib-test"

set_unless[:apache_solr][:memory]       = {}
set_unless[:apache_solr][:memory][:min] = '128m'
set_unless[:apache_solr][:memory][:max] = '256m'
