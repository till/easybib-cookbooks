#
# Cookbook Name:: cron
# Provider:: d
#
# Copyright 2010-2013, Opscode, Inc.
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

action :delete do
  file "/etc/cron.d/#{new_resource.name}" do
    action :delete
  end
end

action :create do
  if node['platform_family'] == "solaris2"
    fail "Solaris does not support cron jobs in /etc/cron.d"
  end
  t = template "/etc/cron.d/#{new_resource.name}" do
    cookbook new_resource.cookbook
    source "cron.d.erb"
    mode "0644"
    variables({
        :name => new_resource.name,

        :minute => new_resource.minute,
        :hour => new_resource.hour,
        :day => new_resource.day,
        :month => new_resource.month,
        :weekday => new_resource.weekday,

        :command => new_resource.command,
        :user => new_resource.user,

        :mailto => new_resource.mailto,
        :path => new_resource.path,
        :home => new_resource.home,
        :shell => new_resource.shell
      })
    action :create
  end
  new_resource.updated_by_last_action(t.updated_by_last_action?)
end
