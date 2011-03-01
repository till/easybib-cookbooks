configs = node[:buildconfigs][:configs]
configs.each do |config|
  directory "/var/lib/jenkins/jobs/#{config}" do
    mode "0755"
    owner "jenkins"
    group "jenkins"
    action :create
    recursive true
  end
  cookbook_file "/var/lib/jenkins/jobs/#{config}/config.xml" do
    source "buildconfigs/#{config}.xml"
    mode "0644"
    owner "jenkins"
    group "jenkins"
  end
end


configs = node[:buildconfigs][:configs]
configs.each do |config|
  directory "/var/lib/jenkins/jobs/#{config}" do
    mode "0755"
    owner "jenkins"
    group "jenkins"
    action :create
    recursive true
  end
  cookbook_file "/var/lib/jenkins/jobs/#{config}/config.xml" do
    source "buildconfigs/#{config}.xml"
    mode "0644"
    owner "jenkins"
    group "jenkins"
  end
#  execute "jenkins-config: installing config #{config}" do
#    #TODO: This is vagrant-specific. Maybe change it to webspace for configs and wget?
#    command "sudo mkdir /var/lib/jenkins/jobs/#{config} && cp /vagrant/cookbooks/jenkins/files/buildconfigs/#{config}.xml /var/lib/jenkins/jobs/#{config}/config.xml"
#	end
end


directory "/var/lib/jenkins" do
  recursive true
  owner "jenkins"
  mode 0700
end

service "jenkins" do
  action :restart
end
