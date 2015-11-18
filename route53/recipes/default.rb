#
# Cookbook Name:: route53
# Recipe:: default
#
# Copyright 2011, Heavy Water Operations, LLC
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
chef_gem "aws-sdk-core" do
  compile_time true
  action :install
  version node['route53']['aws_sdk_version']
end

require 'aws-sdk-core'

# Putting this in library causes an error since gem is not available when
# libraries are loaded
# 'defined?' is for chefspec warnings since file may be loaded multiple times
::Chef::Provider::RECORD_WAIT_TIME = 20 unless defined? ::Chef::Provider::RECORD_WAIT_TIME
::Chef::Provider::RECORD_WAIT_TRIES = 10 unless defined? ::Chef::Provider::RECORD_WAIT_TRIES
::Chef::Provider::ROUTE53_ERRORS = [
  Aws::Route53::Errors::PriorRequestNotComplete,
  Aws::Route53::Errors::Throttling
] unless defined? ::Chef::Provider::ROUTE53_ERRORS

require 'rubygems'
Gem.clear_paths
