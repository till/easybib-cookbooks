# for some reason, most VMs fail with outdated package lists
execute "aptitude update" do
  command "apt-get -y -f -q update"
end

#execute "update gems" do
#  command "gem update -B 10 --no-rdoc --no-test --no-ri"
#end

execute "session fix for vagrant setups/installs" do
  command "chmod 0777 /vagrant_data/var/sessions/"
  only_if do
    File.exists?("/vagrant_data/var/sessions/")
  end
end
