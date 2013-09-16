cookbook_file "/tmp/percona.pub" do
  source "percona.pub"
  mode   "0644"
end

execute "import key" do
  command "apt-key add /tmp/percona.pub"
end

execute "update-percona-apt" do
  command "apt-get -y -f -q update"
  action :nothing
end


template "/etc/apt/sources.list.d/percona.list" do
  source "percona.list.erb"
  mode 0644
  notifies :run, "execute[update-percona-apt]", :immediately
end
