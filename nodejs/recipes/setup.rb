package "g++"
package "curl"
package "libssl-dev"

dir_version  = node[:nodejs][:version].gsub('.', '')
node_prefix  = "/usr/local/node#{version}"
node_tmp_dir = "/tmp/node-v#{node[:nodejs][:version]}"

remote_file "/tmp/node-v#{node[:nodejs][:version]}.tar.gz" do
  source "http://nodejs.org/dist/node-v#{node[:nodejs][:version]}.tar.gz"
  mode "0644"
end

execute "untar" do
  command "tar -zxf /tmp/node-v#{node[:nodejs][:version]}.tar.gz"
end

execute "configure" do
  command "./configure --prefix=#{node_prefix}"
  cwd node_tmp_dir
end

execute "make && make install" do
  command "make && make install"
  cwd node_tmp_dir
end

include_recipe "nodejs::user"
include_recipe "nodejs::upstart"

# todo:
# setup monit script

