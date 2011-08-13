# create data dir
directory "#{node[:elasticsearch][:ebsdir]}/elasticsearch-data" do
  owner     node[:elasticsearch][:user]
  group     node[:elasticsearch][:group]
  mode      "0755"
  action    :create
  recursive true
end

# create logs dir
directory "#{node[:elasticsearch][:basedir]}/elasticsearch-logs" do
  owner     node[:elasticsearch][:user]
  group     node[:elasticsearch][:group]
  mode      "0755"
  action    :create
  recursive true
end

# install configuration file
dir = "#{node[:elasticsearch][:basedir]}/#{node[:elasticsearch][:version].gsub('.tar.gz', '')}"
template "#{dir}/config/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner  node[:elasticsearch][:user]
  group  node[:elasticsearch][:group]
end
