package "git-core"

dir      = node[:elasticsearch][:version].gsub('.tar.gz', '')
base_dir = "#{node[:elasticsearch][:basedir]}/#{dir}/bin"

# this is where we git checkout the servicewrapper to
service_dir="#{node[:elasticsearch][:basedir]}/elasticsearch-service"

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

execute "patch ES_HOME in start script" do
  command "sed -i 's,ES_HOME=`dirname \"$SCRIPT\"`/../..,ES_HOME=#{node[:elasticsearch][:basedir]}/#{dir},g' elasticsearch"
  cwd     "#{service_dir}/service"
end

execute "register as a service" do
  command "#{base_dir}/service/elasticsearch install"
  not_if  do File.symlink?("/etc/init.d/elasticsearch") end
end

service "elasticsearch" do
  action :start
end
