ppa = ""
ppa << " --yes " if node["lsb"]["codename"] == 'precise'
ppa << node["apt"]["easybib"]["ppa"]

execute "update_easybib_sources" do
  command "apt-get -y -f -q update"
  action :nothing
end

execute "discover ppa: #{node["apt"]["easybib"]["ppa"]}" do
  command "add-apt-repository #{ppa}"
  notifies :run, "execute[update_easybib_sources]", :immediately
end
