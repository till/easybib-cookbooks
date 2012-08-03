#
# Author:: Ben Black (<b@boundary.com>)
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Recipe:: default
#
# Copyright 2010, Boundary
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "bprobe::dependencies"

# create the meter in the boundary api
bprobe node[:fqdn] do
  action :create
end

# setup the config directory
directory node[:boundary][:bprobe][:etc][:path] do
  action :create
  mode 0755
  owner "root"
  group "root"
  recursive true
end

# download and install the meter cert and key files
bprobe_certificates node[:fqdn] do
  action :install
end

# install the bprobe package

package "bprobe"

# start the bprobe service
service "bprobe" do
  supports value_for_platform(
    "debian" => { "4.0" => [ :restart ], "default" => [ :restart ] },
    "ubuntu" => { "default" => [ :restart ] },
    "default" => { "default" => [:restart ] }
  )
  action [ :start, :enable ]
end

# enforce the ca cert
cookbook_file "#{node[:boundary][:bprobe][:etc][:path]}/ca.pem" do
  source "ca.pem"
  mode 0600
  owner "root"
  group "root"
  notifies :restart, resources(:service => "bprobe")
end

# enforce the main config file
template "#{node[:boundary][:bprobe][:etc][:path]}/bprobe.defaults" do
  source "bprobe.defaults.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "bprobe")
end
