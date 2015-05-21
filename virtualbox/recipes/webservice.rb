#
# Cookbook Name:: virtualbox
# Recipe:: webservice
#
# Copyright 2012, Ringo De Smet
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

include_recipe "virtualbox::user"

template "/etc/vbox/vbox.cfg" do
  source "vbox.cfg.erb"
end

directory "vboxweb-service log folder" do
  path node['virtualbox']['webservice']['log']['location']
  owner node['virtualbox']['user']
  group node['virtualbox']['group']
  mode '0755'
end

# It is very hard to get vboxwebsrv to work correctly with password authentication
# If anyone can get this working, feel free to submit a changed cookbook!
execute "Disable vboxwebsrv auth library" do
  command "VBoxManage setproperty websrvauthlibrary null"
  user "#{node['virtualbox']['user']}"
  action :run
  environment ({'HOME' => "/home/#{node['virtualbox']['user']}"})
end

service "vboxweb-service" do
  action [:enable, :start]
end
