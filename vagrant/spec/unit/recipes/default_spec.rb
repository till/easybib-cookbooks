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

RSpec.describe 'vagrant::default' do
  include_context 'mock vagrant_sha256sum'

  context 'on an Ubuntu node' do
    let(:debian) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04',
        file_cache_path: '/var/tmp'
      ).converge(described_recipe)
    end

    context 'with default attributes' do
      it 'includes the Debian platform recipe' do
        expect(debian).to include_recipe('vagrant::debian')
      end

      it 'does not install plugins by default' do
        expect(debian).to_not include_recipe('vagrant::install_plugins')
      end
    end

    context 'with an array of plugins to install' do
      it 'includes the install_plugins recipe' do
        debian.node.set['vagrant']['plugins'] = ['vagrant-omnibus']
        debian.node.set['vagrant']['user'] = 'vagrant'
        debian.converge(described_recipe)

        expect(debian).to include_recipe('vagrant::install_plugins')
      end
    end
  end

  context 'on a Windows node' do
    cached(:windows) do
      ChefSpec::SoloRunner.new(
        platform: 'windows',
        version:  '2012R2'
      ).converge(described_recipe)
    end

    it 'includes the Windows platform recipe' do
      expect(windows).to include_recipe('vagrant::windows')
    end
  end
end
