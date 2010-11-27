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

node[:dev][:dirs].each { |dir|
  directory "/www/#{dir}/current" do
    mode "0755"
    owner "teracode"
    action :create
    recursive true
  end
}

template "/etc/nginx/sites-enabled/sites.conf" do
  source "vhost.conf.erb"
  mode "0644"
  owner "www-data"
  group "www-data"
end
