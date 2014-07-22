package "curl"
package "nodejs"

npm_bin = "/usr/bin/npm"

remote_file "#{Chef::Config[:file_cache_path]}/install-npm.sh" do
  source node["nodejs"]["npm"]["install_url"]
  mode "0755"
  not_if do
    File.exists?(npm_bin)
  end
end

execute "Install the latest npm" do
  command "#{Chef::Config[:file_cache_path]}/install-npm.sh"
  environment ({"clean" => "no"})
  not_if do
    File.exist?(npm_bin)
  end
end
