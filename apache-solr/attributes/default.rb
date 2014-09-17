default["apache_solr"]            = {}
default["apache_solr"]["version"]  = "4.6.0"
default["apache_solr"]["user"]     = "root"
default["apache_solr"]["group"]    = "root"
default["apache_solr"]["data_dir"] = "/solr-data/research-collection/"
default["apache_solr"]["base_dir"] = "/opt/apache"
default["apache_solr"]["log_file"] = "/var/log/apache-solr.log"

set_unless["apache_solr"]["mirror"] = "http://archive.apache.org/dist/lucene/solr/"
set_unless["apache_solr"]["app"]    = "easybib-test"
set_unless["apache_solr"]["config_source_dir"]    = "/srv/www/research_solr/current/"

set_unless["apache_solr"]["memory"]       = {}
set_unless["apache_solr"]["memory"]["min"] = '128m'
set_unless["apache_solr"]["memory"]["max"] = '256m'
