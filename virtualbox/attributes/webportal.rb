#
# Cookbook Name:: virtualbox
# Attributes:: webportal
#
# Copyright 2012, Ringo De Smet
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

# Map major virtualbox version numbers to the phpvirtualbox build numbers
# https://code.google.com/p/phpvirtualbox/downloads/list
default['virtualbox']['webportal']['versions'] = {
    '4.0' => '7',
    '4.1' => '9',
    '4.2' => '8',
    '4.3' => '0'
}

default['virtualbox']['webportal']['installdir'] = "/var/www"
default['virtualbox']['webportal']['enable-apache2-default-site'] = false
