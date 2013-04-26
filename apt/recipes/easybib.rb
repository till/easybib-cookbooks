ppa=["easybib/ppa"]
if node.attribute?(:scalarium) && node[:scalarium][:cluster][:name] == "EasyBib Playground"
  ppa=["easybib/test", "easybib/multipackagetest"]
end

if node.attribute?(:vagrant)
  ppa=["easybib/test", "easybib/multipackagetest"]
end

ppa.each do |p|
  execute "add #{ppa}" do
    command "add-apt-repository ppa:#{ppa}"
  end
end

execute "update sources" do
  command "apt-get -y -f -q update"
end
