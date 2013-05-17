ppa="ppa:easybib/test-opt"

execute "add #{ppa}" do
  command "add-apt-repository ppa:#{ppa}"
end

execute "update sources" do
  command "apt-get -y -f -q update"
end
