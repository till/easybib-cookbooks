template "/etc/apt/sources.list.d/prosody.list" do
  source "sources.list.erb"
  mode "0644"
end

execute "import key" do
  command "wget http://prosody.im/files/prosody-debian-packages.key -O- | sudo apt-key add -"
end

execute "update sources" do
  command "apt-get -y update"
end
