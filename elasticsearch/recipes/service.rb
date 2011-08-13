package "git-core"

dir      = node[:elasticsearch][:version].gsub('.tar.gz', '')
base_dir = "#{node[:elasticsearch][:basedir]}/#{dir}/bin"

# this is where we git checkout the servicewrapper to
service_dir="#{node[:elasticsearch][:basedir]}/elasticsearch-service"

# Each time the setup is run, the following happens
# * determine if the service wrapper is installed and attempt to stop ElasticSearch
# * delete the symlink
# * delete the servicewrapper checkout
if File.exists?('/etc/init.d/elasticsearch')
  execute "stop ElasticSearch" do
    command "/etc/init.d/elasticsearch stop"
  end
  execute "delete service wrapper's symlink" do
    command "rm /etc/init.d/elasticsearch"
  end
  directory "#{service_dir}" do
    action    :delete
    recursive true
  end
end

git "#{service_dir}" do
  repository "git://github.com/elasticsearch/elasticsearch-servicewrapper.git"
  reference "master"
  action :sync
end

link "#{base_dir}/service" do
  to "#{service_dir}/service"
end

#execute "unable ulimit" do
#  command "sed -i 's,#ULIMIT_N=,ULIMIT_N=32000,g' elasticsearch"
#  cwd     "#{service_dir}/service"
#end

# todo maybe add this to service-elasticsearch.conf.erb
execute "patch ES_HOME in start script" do
  command "sed -i 's,ES_HOME=`dirname \"$SCRIPT\"`/../..,ES_HOME=#{node[:elasticsearch][:basedir]}/#{dir},g' elasticsearch"
  cwd     "#{service_dir}/service"
end

execute "register elasticsearch as a service" do
  command "#{base_dir}/service/elasticsearch install"
  not_if  do File.symlink?("/etc/init.d/elasticsearch") end
end

template "#{base_dir}/service/config/elasticsearch.conf" do
  source "service-elasticsearch.conf.erb"
  owner  node[:elasticsearch][:user]
  group  node[:elasticsearch][:group]
  mode   "0644"
end

service "elasticsearch" do
  action :start
end
