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

directory "/www/notes" do
  mode "0755"
  owner "teracode"
  action :create
end
