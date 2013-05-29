ppa = node["apt"]["easybib"]["ppa"]

execute "add #{ppa}" do
  command "add-apt-repository #{ppa}"
end

execute "update sources" do
  command "apt-get -y -f -q update"
end
