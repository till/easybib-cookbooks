ppa=["easybib/ppa"]
if node.attribute?(:scalarium) && node[:scalarium][:cluster][:name] == "EasyBib Playground"
  ppa=["easybib/test", "easybib/multipackagetest"]
end

if !node.attribute?(:scalarium)
  ppa=["easybib/test", "easybib/multipackagetest"]
end

ppa.each do |p|
  Chef::Log.debug("Adding #{p}")
  execute "add #{p}" do
    command "add-apt-repository ppa:#{p}"
  end
end

Chef::Log.debug("Updating sources.")
execute "update sources" do
  command "apt-get -y -f -q update"
end
