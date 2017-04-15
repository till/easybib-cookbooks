#
# Cookbook Name:: bash
# Recipe:: default
#
template "/home/vagrant/.bash_aliases" do
  source "bash_aliases.erb"
  mode "0644"
  owner "vagrant"
  group "vagrant"
end



# copied from here: https://github.com/fnichol/chef-bashrc/blob/master/recipes/system.rb

if platform?("ubuntu")
  # shortcut the sourcing of ${HOME}/.profile which on Ubuntu sources
  # ${HOME}/.bashrc which sets prompts (again!) and other undesirables
  file "/etc/skel/.bash_login" do
    owner   "root"
    group   "root"
    mode    "0644"
    action  :create
  end

  file "/root/.bash_login" do
    owner   "root"
    group   "root"
    mode    "0644"
    action  :create
  end

  # support for vagrant user if using vagrant
  file "/home/vagrant/.bash_login" do
    owner   "vagrant"
    group   "vagrant"
    mode    "0644"
    action  :create
    only_if %{test -d /home/vagrant}
  end
end