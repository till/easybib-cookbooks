#
# Cookbook Name:: cron
# Resource:: d
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

actions :create, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => "cron"

attribute :minute, :kind_of => [Integer, String], :default => "*"
attribute :hour, :kind_of => [Integer, String], :default => "*"
attribute :day, :kind_of => [Integer, String], :default => "*"
attribute :month, :kind_of => [Integer, String], :default => "*"
attribute :weekday, :kind_of => [Integer, String], :default => "*"

attribute :command, :kind_of => String, :required => true

attribute :user, :kind_of => String, :default => "root"

attribute :mailto, :kind_of => [String, NilClass]
attribute :path, :kind_of => [String, NilClass]
attribute :home, :kind_of => [String, NilClass]
attribute :shell, :kind_of => [String, NilClass]

def initialize(*args)
  super
  @action = :create
end
