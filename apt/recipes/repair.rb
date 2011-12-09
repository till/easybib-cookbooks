gem_package "apt-repair-sources" do
  options "--no-rdoc --no-ri"
  action :install
end

execute "test-sources" do
  command "apt-repair-sources"
end
