package "git-core"

dir      = node[:elasticsearch][:version].gsub('.tar.gz', '')
base_dir = "/opt/#{dir}/bin"

git "/opt/elasticsearch-service" do
  repository "git://github.com/elasticsearch/elasticsearch-servicewrapper.git"
  reference "master"
  action :sync
end

link "#{base_dir}/service" do
  to "/opt/elasticsearch-service/service"
end

execute "patch ES_HOME in start script" do
  command "sed -i 's,ES_HOME=`dirname \"$SCRIPT\"`/../..,ES_HOME=/opt/#{dir},g' elasticsearch"
  cwd     "/opt/elasticsearch-service/service"
end

execute "register as a service" do
  command "#{base_dir}/service/elasticsearch install"
  not_if  do File.symlink?("/etc/init.d/elasticsearch") end
end

service "elasticsearch" do
  action :start
end
