#
# Cookbook Name:: sinopia-github
#
# Author:: A pile of puppies
#
# Copyright 2015
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

nodejs_npm 'sinopia-github' do
  path node['sinopia-github']['install_path']
  action :install
end

template File.join(node['sinopia']['confdir'], 'config.yaml') do
  source 'config.yaml.erb'
  notifies :restart, 'service[sinopia]', :delayed
end
