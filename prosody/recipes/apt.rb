template "/etc/apt/sources.list.d/prosody.list" do
  source "sources.list.erb"
  mode "0644"
end

key_file = "#{Chef::Config[:file_cache_path]}/prosody-debian-packages.key"

remote_file key_file do
  source "http://prosody.im/files/prosody-debian-packages.key"
end

execute "import key" do
  command "cat #{key_file} | sudo apt-key add -"
end

execute "update sources" do
  command "apt-get -y update"
end
