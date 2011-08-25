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

node[:elasticsearch][:home] = "#{node[:elasticsearch][:basedir]}/#{dir}"

execute "patch ES_HOME in start script" do
  command "sed -i 's,ES_HOME=`dirname \"$SCRIPT\"`/../..,ES_HOME=#{node[:elasticsearch][:home]},g' elasticsearch"
  cwd     "#{service_dir}/service"
end

execute "register elasticsearch as a service" do
  command "#{base_dir}/service/elasticsearch install"
  not_if  do File.symlink?("/etc/init.d/elasticsearch") end
end

if node[:ec2]
  case node[:ec2][:instance_type]
    when "t1.micro"
      mem_min = 256
      mem_max = 256
    when "m1.small"
      mem_min = 1024
      mem_max = 1024
    when "m1.large"
      mem_min = 6000
      mem_max = 6000
    when "m1.xlarge"
      mem_min = node[:elasticsearch][:memory][:max]
      mem_max = node[:elasticsearch][:memory][:max]
    when "m2.xlarge"
      mem_min = 15000
      mem_max = 15000
    when "m2.2xlarge"
      mem_min = 30000
      mem_max = 30000
    when "m2.4xlarge"
      mem_min = 60000
      mem_max = 60000
    when "c1.medium"
      mem_min = 900
      mem_max = 900
    when "c1.xlarge"
      mem_min = 6000
      mem_max = 6000
    else
      raise Chef::Exceptions::Env, "Unknown instance identifier: #{node[:ec2][:instance_type]}"
  end
else
  # assume developer VM
  mem_min = 256
  mem_max = 256
end

template "#{service_dir}/service/elasticsearch.conf" do
  source "service-elasticsearch.conf.erb"
  owner  node[:elasticsearch][:user]
  group  node[:elasticsearch][:group]
  mode   "0644"
  variables(
    :mem_min => mem_min,
    :mem_max => mem_max,
    :es_home => node[:elasticsearch][:home]
  )
end

service "elasticsearch" do
  action :start
end
