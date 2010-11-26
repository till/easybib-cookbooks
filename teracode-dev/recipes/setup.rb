include_recipe "teracode-dev::users"

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

dirs = [ 'notes', 'research' ]

dirs.each { |dir|
  directory "/www/#{dir}/current" do
    mode "0755"
    owner "teracode"
    action :create
    recursive true
  end
}
