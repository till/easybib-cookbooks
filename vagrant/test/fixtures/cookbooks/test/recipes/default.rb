# Cookbook Name:: vagrant
# Test:: default

# Copyright 2015 Joshua Timberman
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

execute 'apt-get update' if platform_family?('debian')

include_recipe 'build-essential'
include_recipe 'vagrant'

# How meta...
vagrant_plugin 'vagrant-aws'

# A user that doesn't exist...
donut_home = case node['os']
             when 'darwin' then '/Users/donuts'
             when 'linux' then '/home/donuts'
               # untested, this is run in test kitchen, but i don't have a
               # current windows box
             when 'windows' then 'C:/Users/donuts'
             end

user 'donuts' do
  uid '777'
  gid 'staff' if ['darwin'].include?(node['os'])
  shell '/bin/bash'
  home donut_home
  supports manage_home: true
end

directory donut_home do
  owner 'donuts'
  group 'staff' if ['darwin'].include?(node['os'])
  recursive true
end

# Use a different plugin for the donuts user. This doesn't work on OS
# X though, getting a permission problem on installing ffi.
vagrant_plugin 'vagrant-ohai' do
  version '0.1.12'
  user 'donuts'
end
