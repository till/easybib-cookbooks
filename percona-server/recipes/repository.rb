execute "download key" do
  command "gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A"
end

execute "import key" do
  command "gpg -a --export CD2EFD2A | apt-key add -"
end

template "/etc/apt/sources.list.d/percona.list" do
  source "percona.list.erb"
  mode 0644
end

execute "update apt" do
  command "apt-get -q update"
end
