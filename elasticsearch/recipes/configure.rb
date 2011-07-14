# create data dir
directory "#{node[:elasticsearch][:basedir]}/elasticsearch-data" do
  owner     "root"
  mode      "0755"
  action    :create
  recursive true
end

# create logs dir
directory "#{node[:elasticsearch][:basedir]}/elasticsearch-logs" do
  owner     "root"
  mode      "0755"
  action    :create
  recursive true
end

# install configuration file
dir = "#{node[:elasticsearch][:basedir]}/#{node[:elasticsearch][:version].gsub('.tar.gz', '')}"
template "#{dir}/config/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner  "root"
  group  "root"
end
