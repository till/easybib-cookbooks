#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Attributes:: bprobe
#
# Copyright 2011, Boundary
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

default[:boundary][:bprobe][:bin][:path] = "/usr/local"
default[:boundary][:bprobe][:etc][:path] = "/etc/bprobe"

default[:boundary][:bprobe][:collector][:hostname] = "collector.boundary.com"
default[:boundary][:bprobe][:collector][:port] = "4740"

if attribute?(:scalarium)
  default[:boundary][:bprobe][:tags] = [ node[:scalarium][:cluster][:name].gsub(/\s/,'') ]
  default[:boundary][:bprobe][:tags] += node[:scalarium][:instance][:roles]
else
  default[:boundary][:bprobe][:tags] = []
end
