#
# Cookbook Name:: vpc-classiclink
# Recipe:: install
#
include_recipe 'python::pip'

python_pip "awscli" do
 action :install
end

directory "/root/.aws/" do
  owner "root"
  group "root"
  mode 0755
  action :create
  recursive true
end

template "/root/.aws/config" do
  source "aws.config.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/root/.aws/credentials" do
  source "aws.credentials.erb"
  owner "root"
  group "root"
  mode 0755
end
