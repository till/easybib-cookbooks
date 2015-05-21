#
# Cookbook Name:: virtualbox
# Attributes:: webservice
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

# Settings for activating the included vboxweb-service
default['virtualbox']['webservice']['log']['location'] = '/var/log/vboxwebsrv'
default['virtualbox']['webservice']['log']['rotate'] = 5 # archived log files
default['virtualbox']['webservice']['log']['size'] = 10485760 # 10 MByte
default['virtualbox']['webservice']['log']['interval'] = 604800 # 1 week
