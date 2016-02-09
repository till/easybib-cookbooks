# Cookbook Name:: vagrant
# Resource:: plugin

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

actions :install, :remove, :uninstall

default_action :install

attribute :plugin_name, name_attribute: true
attribute :version, kind_of: [String]
attribute :installed, kind_of: [TrueClass, FalseClass]
attribute :installed_version, kind_of: [String]
attribute :user, kind_of: [String], default: nil
attribute :password, kind_of: String, default: nil
attribute :sources, kind_of: [String, Array], default: nil
