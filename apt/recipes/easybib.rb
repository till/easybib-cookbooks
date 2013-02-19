ppa="easybib/ppa"
if get_cluster_name() == "EasyBib Playground"
  ppa="easybib/test"
end

execute "add #{ppa}" do
  command "add-apt-repository ppa:#{ppa}"
end

execute "update sources" do
  command "apt-get -y -f -q update"
end
