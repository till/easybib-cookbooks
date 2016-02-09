# Author:: Doug Ireton
# Copyright:: Copyright (c) 2015
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

RSpec.describe 'vagrant::windows' do
  include_context 'mock vagrant_sha256sum'

  context 'with default attributes' do
    VAGRANT_DEFAULT_VERSION = '1.7.4'

    cached(:windows_node) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version:  '2012R2'
      ) do |node|
        node.set['vagrant']['msi_version'] = VAGRANT_DEFAULT_VERSION
      end.converge(described_recipe)
    end

    it "installs Vagrant version #{VAGRANT_DEFAULT_VERSION}" do
      expect(windows_node).to install_windows_package('Vagrant').with(
        source: "https://releases.hashicorp.com/vagrant/#{VAGRANT_DEFAULT_VERSION}/vagrant_#{VAGRANT_DEFAULT_VERSION}.msi",
        version: VAGRANT_DEFAULT_VERSION
      )
    end
  end

  context 'when you override the version' do
    VAGRANT_OVERRIDE_VERSION = '1.88.88'
    cached(:windows_node) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version: '2012R2'
      ) do |node|
        node.set['vagrant']['version'] = VAGRANT_OVERRIDE_VERSION
        node.set['vagrant']['msi_version'] = VAGRANT_OVERRIDE_VERSION
      end.converge(described_recipe)
    end

    it "installs Vagrant version #{VAGRANT_OVERRIDE_VERSION}" do
      expect(windows_node).to install_windows_package('Vagrant').with(
        source: "https://releases.hashicorp.com/vagrant/#{VAGRANT_OVERRIDE_VERSION}/vagrant_#{VAGRANT_OVERRIDE_VERSION}.msi",
        version: VAGRANT_OVERRIDE_VERSION
      )
    end
  end
end
