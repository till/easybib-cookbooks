# Cookbook Name:: vagrant
# Library:: helpers

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

require 'uri'
require 'open-uri'

module Vagrant
  module Helpers
    def vagrant_package_uri
      "#{vagrant_base_uri}#{package_version}/#{package_name}"
    end

    def vagrant_sha256sum
      sha256sums = fetch_platform_checksums_for_version
      extract_checksum(sha256sums)
    end

    private

    def vagrant_base_uri
      'https://releases.hashicorp.com/vagrant/'
    end

    def package_name
      "vagrant_#{package_version}#{package_extension}"
    end

    def package_version
      node['vagrant']['version']
    end

    def package_extension
      extension = value_for_platform_family(
        'mac_os_x' => '.dmg',
        'windows' => '.msi',
        'debian' => '_x86_64.deb',
        %w(rhel suse fedora) => '_x86_64.rpm'
      )

      fail "HashiCorp doesn't provide a Vagrant package for
          the #{node['platform']} platform." if extension.nil?

      extension
    end

    def fetch_platform_checksums_for_version
      checksums_url = "#{vagrant_base_uri}#{package_version}/vagrant_#{package_version}_SHA256SUMS?direct"
      open(checksums_url).readlines
    end

    def extract_checksum(sha256sums)
      sha256sums.grep(/#{package_name}/)[0].split.first
    end
  end
end

Chef::Recipe.send(:include, Vagrant::Helpers)
