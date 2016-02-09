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

name             'vagrant'
maintainer       'Joshua Timberman'
maintainer_email 'cookbooks@housepub.org'
license          'Apache 2.0'
description      'Installs Vagrant and provides a vagrant_plugin LWRP for installing Vagrant plugins.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.2'

source_url 'https://github.com/jtimberman/vagrant-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/jtimberman/vagrant-cookbook/issues' if respond_to?(:issues_url)

supports 'debian', '>= 6.0'
supports 'ubuntu', '>= 12.04'
supports 'redhat', '>= 6.3'
supports 'centos', '>= 6.4'
# supports 'windows'
# supports 'mac_os_x'

# depends 'dmg', '>= 2.2.2'
# depends 'windows', '~> 1.38'
