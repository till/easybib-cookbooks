package "openjdk-6-jre-headless"
package "openjdk-6-jre-lib"

remote_file "/tmp/ElasticLoadBalancing.zip" do
   source "http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip"
   mode "0755"
end

execute "unzip elb cli tools" do
  command "unzip /tmp/ElasticLoadBalancing.zip"
end

# this assumes: node["aws_credentials"]["key"] and node["aws_credentials"]["secret"]
template "/root/.aws-credential-file" do
  source "credential-file.erb"
  mode "0600"
  owner "root"
  group "root"
end

template "/etc/init.d/elb" do
  source "elb.erb"
  mode "0755"
  owner "root"
  group "root"
end

include_recipe "aws-elb::configure"
