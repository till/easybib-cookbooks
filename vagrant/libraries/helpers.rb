#
# Author:: Joshua Timberman <opensource@housepub.org>
# Copyright:: Copyright (c) 2014, Joshua Timberman
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'uri'
require 'open-uri'

def vagrant_base_uri
  'https://dl.bintray.com/mitchellh/vagrant/'
end

def vagrant_platform_package(vers = nil)
  case node['os']
  when 'darwin'
    "vagrant_#{vers}.dmg"
  when 'windows'
    "vagrant_#{vers}.msi"
  when 'linux'
    case node['platform_family']
    when 'debian'
      "vagrant_#{vers}_x86_64.deb"
    when 'fedora', 'rhel'
      "vagrant_#{vers}_x86_64.rpm"
    end
  end
end

def vagrant_sha256sum(vers = nil)
  # fetch the version-specific sha256sum file
  # grep for the platform-specific package name
  sha256sums = open(URI.join(vagrant_base_uri, "#{vers}_SHA256SUMS?direct"))
  sha256sums.readlines.grep(/#{vagrant_platform_package(vers)}/)[0].split.first
end

def vagrant_package_uri(vers = nil)
  URI.join(vagrant_base_uri, vagrant_platform_package(vers)).to_s
end
