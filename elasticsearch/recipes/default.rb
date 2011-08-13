# TODO: https://launchpad.net/~rgl/+archive/elasticsearch
include_recipe "java::default"

tmp_file = "#{node[:elasticsearch][:basedir]}/#{node[:elasticsearch][:version]}"

directory "#{node[:elasticsearch][:basedir]}" do
  owner     node[:elasticsearch][:user]
  group     node[:elasticsearch][:group]
  mode      "0755"
  action    :create
  recursive true
end

remote_file "#{tmp_file}" do
  source "#{node[:elasticsearch][:download]}/#{node[:elasticsearch][:version]}"
  mode   "0644"
  not_if do File.directory?("#{tmp_file.gsub('.tar.gz', '')}") end
end

execute "extract #{node[:elasticsearch][:version]}" do
  command "tar -zxvf #{tmp_file}"
  not_if  do !File.exist?(tmp_file) end
  cwd     "#{node[:elasticsearch][:basedir]}"
end

include_recipe "elasticsearch::configure"
include_recipe "elasticsearch::restart"
