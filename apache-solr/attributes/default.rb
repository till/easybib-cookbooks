default[:apache_solr]            = {}
default[:apache_solr][:version]  = "3.5.0"
default[:apache_solr][:user]     = "root"
default[:apache_solr][:group]    = "root"
default[:apache_solr][:base_dir] = "/opt/apache"

set_unless[:apache_solr][:mirror] = "http://apache.imsam.info/lucene/solr"
