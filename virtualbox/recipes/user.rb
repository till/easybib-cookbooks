#
# Cookbook Name:: virtualbox
# Recipe:: user
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

# For the user to be created successfully, a data bag item with the MD5 hashed password
# needs to be added.

include_recipe "apt"

package "build-essential"
gem_package "ruby-shadow"

user 'virtualbox-user' do
  username node['virtualbox']['user']
  gid node['virtualbox']['group']
  password data_bag_item('passwords','virtualbox-user')['password']
  home "/home/#{node['virtualbox']['user']}"
  shell "/bin/bash"
  system true
  manage_home true
end
