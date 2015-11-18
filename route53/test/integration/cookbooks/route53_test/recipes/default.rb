#
# Cookbook Name:: route53_test
# Recipe:: default
#
# Copyright 2014, Heavy Water Operations
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

if node['platform_family'] == 'debian'
  update_cache = execute "update apt" do
                  command "apt-get update"
                end
  update_cache.run_action( :run )
end

package 'ntpdate'

execute "update system time" do
  command 'ntpdate ntp.ubuntu.com'
  user 'root'
end

include_recipe "route53"

route53_record node[:records][:generic_record][:name] do
  value                 node[:records][:generic_record][:value]
  type                  node[:records][:generic_record][:type]
  ttl                   node[:records][:generic_record][:ttl]
  region                node[:route53][:region]
  zone_id               node[:route53][:zone_id]
  action                :create
end

route53_record node[:records][:alias_record][:name] do
  type                  node[:records][:alias_record][:type]
  zone_id               node[:route53][:zone_id]
  ttl                   node[:records][:generic_record][:ttl]
  region                node[:route53][:region]
  action                :create
  only_if               { node[:records][:alias_record][:run] }
end

route53_record "#{node[:records][:generic_record][:name]}_delete" do
  name                  node[:records][:generic_record][:name]
  type                  node[:records][:generic_record][:type]
  zone_id               node[:route53][:zone_id]
  ttl                   node[:records][:generic_record][:ttl]
  region                node[:route53][:region]
  action                :delete
end
