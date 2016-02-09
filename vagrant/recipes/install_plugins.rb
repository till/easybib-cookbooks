# Cookbook Name:: vagrant
# Recipe:: install_plugins

# Copyright 2013, Joshua Timberman
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

node['vagrant']['plugins'].each do |plugin|
  if plugin.respond_to?(:keys)
    vagrant_plugin plugin['name'] do
      user node['vagrant']['user'] if node['vagrant']['user']
      password node['vagrant']['password'] if node['vagrant']['password']
      version plugin['version'] if plugin['version']
    end
  else
    vagrant_plugin plugin do
      user node['vagrant']['user'] if node['vagrant']['user']
      password node['vagrant']['password'] if node['vagrant']['password']
    end

  end
end
