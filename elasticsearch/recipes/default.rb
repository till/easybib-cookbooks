# TODO: https://launchpad.net/~rgl/+archive/elasticsearch
include_recipe "java::default"

tmp_file = "/opt/#{node[:elasticsearch][:version]}"

remote_file "#{tmp_file}" do
  source "#{node[:elasticsearch][:download]}/#{node[:elasticsearch][:version]}"
  mode   "0644"
  not_if do File.directory?("#{tmp_file.gsub('.tar.gz', '')}") end
end

execute "extract #{node[:elasticsearch][:version]}" do
  command "tar -zxvf #{tmp_file}"
  not_if  do !File.exist?(tmp_file) end
  cwd     "/opt"
end
