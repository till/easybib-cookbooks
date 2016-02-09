# Cookbook Name:: vagrant
# Recipe:: rhel

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

vagrant_url = node['vagrant']['url'] || vagrant_package_uri
vagrant_checksum = node['vagrant']['checksum'] || vagrant_sha256sum

remote_file "#{Chef::Config[:file_cache_path]}/vagrant.rpm" do
  source vagrant_url
  checksum vagrant_checksum
  notifies :install, 'rpm_package[vagrant]', :immediately
end

rpm_package 'vagrant' do
  source "#{Chef::Config[:file_cache_path]}/vagrant.rpm"
end
