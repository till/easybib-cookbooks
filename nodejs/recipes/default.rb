directory node["nodejs"]["prefix"] do
  mode "0755"
  owner "root"
  group "root"
end

remote_file "#{node["nodejs"]["prefix"]}/node-#{node["nodejs"]["version"]}-linux-x64.tar.gz" do
  source "http://nodejs.org/dist/#{node["nodejs"]["version"]}/node-#{node["nodejs"]["version"]}-linux-x64.tar.gz"
  mode "0644"
  owner "root"
  group "root"
end

execute "extract nodejs install" do
  command "tar -zxf node-#{node["nodejs"]["version"]}-linux-x64.tar.gz"
  cwd node["nodejs"]["prefix"]
end

[ "npm", "node" ].each do |file|
  link "/usr/local/bin/#{file}" do
    to "#{node["nodejs"]["prefix"]}/node-#{node["nodejs"]["version"]}-linux-x64/bin/#{file}"
  end
end
