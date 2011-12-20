cookbook_file "/tmp/percona.pub" do
  source "percona.pub"
  mode   "0644"
end

execute "import key" do
  command "cat /tmp/percona.pub|apt-key -"
end

template "/etc/apt/sources.list.d/percona.list" do
  source "percona.list.erb"
  mode 0644
end

execute "update apt" do
  command "apt-get -y -f -q update"
end
