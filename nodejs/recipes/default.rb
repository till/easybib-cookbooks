directory node["nodejs"]["prefix"] do
  mode "0755"
  owner "root"
  group "root"
end

# Shamelessly borrowed from http://docs.opscode.com/dsl_recipe_method_platform.html
# Surely there's a more canonical way to get arch?
arch = node['kernel']['machine'] =~ /x86_64/ ? "x64" : "x86"

distro_suffix = "-linux-#{arch}"

# package_stub is for example: "node-v0.8.20-linux-x64"
package_stub = "node-v#{node['nodejs']['version']}#{distro_suffix}"
nodejs_tar = "#{package_stub}.tar.gz"
expected_checksum = node['nodejs']['checksum_linux_#{arch}']

nodejs_tar_path = nodejs_tar
if node['nodejs']['version'].split('.')[1].to_i >= 5
  nodejs_tar_path = "v#{node['nodejs']['version']}/#{nodejs_tar_path}"
end

# Let the user override the source url in the attributes
nodejs_bin_url = "#{node['nodejs']['src_url']}/#{nodejs_tar_path}"

remote_file "#{node["nodejs"]["prefix"]}/#{nodejs_tar}" do
  source nodejs_bin_url
  checksum expected_checksum
  mode "0644"
  owner "root"
  group "root"
  action :create_if_missing
end

# Where we will install the binaries and libs to (normally /usr/local):
destination_dir = node['nodejs']['dir']

install_not_needed = File.exists?("#{node['nodejs']['dir']}/bin/node") && `#{node['nodejs']['dir']}/bin/node --version`.chomp == "v#{node['nodejs']['version']}"

execute "extract nodejs install" do
  command "tar -zxf #{nodejs_tar}"
  cwd node["nodejs"]["prefix"]
end

[ "npm", "node" ].each do |file|
  link "/usr/local/bin/#{file}" do
    to "#{node["nodejs"]["prefix"]}/#{package_stub}/bin/#{file}"
  end
end
