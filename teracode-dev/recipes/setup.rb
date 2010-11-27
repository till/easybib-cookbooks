include_recipe "teracode-dev::users"
include_recipe "teracode-dev::sudo"
include_recipe "teracode-dev::dirfix"
include_recipe "teracode-dev::zsh"
include_recipe "easybib-solr::java"

files = [ 'restart_solr141.sh', 'restart_solr_trunk.sh', 'restart_solr.sh', 'update_notes.sh' ]

files.each { |script|
  remote_file "/root/#{script}" do
    source "#{script}"
    mode "0755"
    owner "root"
    group "root"
    action :create
  end
}

include_recipe "teracode-dev::nginx"
include_recipe "teracode-dev::couchdb"
