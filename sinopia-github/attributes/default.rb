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

# encoding: utf-8

## System user running sinopia-github
default['sinopia-github']['user'] = 'sinopia-github'

## sinopia-github gem version (use nil for latest)
default['sinopia-github']['version'] = nil

## sinopia-github users configuration
default['sinopia-github']['admin']['pass'] = 'admin'

default['sinopia-github']['users'] = {}

# default['sinopia-github']['users']['bob']['pass'] = 'incredible'
# default['sinopia-github']['users']['bob']['admin'] = true

# default['sinopia-github']['users']['andy']['pass'] = 'toys'
# default['sinopia-github']['users']['andy']['admin'] = true

# default['sinopia-github']['users']['woody']['pass'] = 'buzz'

## sinopia-github links rewrite URL (url_prefix)
# default['sinopia-github']['public_url'] = 'https://my-npm-private-repo.local/'

## Bind address (IP:port format)
# use nil for default (127.0.0.1:4873)
# use ':port' or '0.0.0.0:port' to listen on all interfaces
default['sinopia-github']['listen'] = nil

## sinopia-github conf directories
# Parents directory MUST exists !
default['sinopia-github']['confdir'] = '/etc/sinopia-github'
default['sinopia-github']['logdir'] = '/var/log/sinopia-github'
default['sinopia-github']['logdays'] = 30
default['sinopia-github']['datadir'] = '/var/lib/sinopia-github'
default['sinopia-github']['loglevel'] = 'warn'

## NodeJS repo list options
default['sinopia-github']['repos'] = {
  'npmjs' => 'https://registry.npmjs.org/' # official npmjs repo
  # 'myrepo' => 'https://myrepo.local/'
}

default['sinopia-github']['mainrepo'] = 'npmjs'

default['sinopia-github']['timeout'] = nil # 30000 ms
default['sinopia-github']['maxage'] = nil # 120 s
default['sinopia-github']['max_body_size'] = nil # 1mb

# Restric read access for admins only
default['sinopia-github']['strict_access'] = false

default['sinopia-github']['use_proxy'] = false
default['sinopia-github']['proxy']['http'] = 'http://something.local/'
default['sinopia-github']['proxy']['https'] = 'https://something.local/'
default['sinopia-github']['proxy']['no_proxy'] = [
  'localhost', '127.0.0.1'
]

## local repos ACL - filters
default['sinopia-github']['filters'] = [
  # {
  #   'name' => 'private-*',
  #   'storage' => 'private-repo'
  # },
  # {
  #   'name' => 'admin-*',
  #   'access' => ['andy', 'woody']
  # },
  #
  ## @admin is a special value for admin account + all admin users
  #
  # {
  #   'name' => 'test-*',
  #   'access' => '@admins'
  # }
]

## Logging options
# type: file | stdout | stderr
# level: trace | debug | info | http (default) | warn | error | fatal
#
# parameters for file: name is filename
#  {type: 'file', path: 'sinopia-github.log', level: 'debug'},
#
# parameters for stdout and stderr: format: json | pretty
#  {type: 'stdout', format: 'pretty', level: 'debug'},
default['sinopia-github']['logs'] = [
  "{type: 'file', path: '#{File.join(node['sinopia-github']['logdir'], 'sinopia-github.log')}', level: '#{node['sinopia-github']['loglevel']}'}"
]
