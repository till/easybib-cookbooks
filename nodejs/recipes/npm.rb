remote_file "#{Chef::Config[:file_cache_path]}/install-npm.sh" do
  source "http://npmjs.org/install.sh"
  mode "0755"
  not_if do
    File.exists?("/usr/bin/npm")
  end
end

execute "Install the latest npm" do
  command "#{Chef::Config[:file_cache_path]}/install-npm.sh"
  not_if do
    File.exist?("/usr/bin/npm")
  end
end
