user "jenkins" do
  home "/home/jenkins"
  shell "/bin/bash"
end

directory "/home/jenkins" do
  recursive true
  owner "jenkins"
  mode 0755
end

# git requires that a user be set to checkout...
template "/home/jenkins/.gitconfig" do
  owner "jenkins"
  source "dot.gitconfig.erb"
  only_if "which git"
end

case node.platform
when "ubuntu"
  include_recipe "apt"
  package "wget"

  apt_repo = node[:jenkins][:apt_repository]
  execute "wget -O - http://#{apt_repo}.org/debian/#{apt_repo}.org.key | apt-key add -"

  remote_file "/etc/apt/sources.list.d/jenkins-ci.org.list" do
    mode "0644"
    source "#{apt_repo}.org.list"
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
end

package "jenkins" do
  action :upgrade
end

service "jenkins" do
  supports :status => true, :restart => true, :start => true, :stop => true
  status_command "/etc/init.d/jenkins status | grep 'jenkins is running'"
  action :start
end

jenkins_plugin node[:jenkins][:plugins]

link "/home/jenkins/lib" do
  to "/var/lib/jenkins"
end
