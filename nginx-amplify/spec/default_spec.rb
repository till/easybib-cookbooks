require_relative 'spec_helper'

describe 'nginx-amplify::default' do

  let(:runner) do
    ChefSpec::Runner.new
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'default' do
    it 'discovers the repository' do
      expect(chef_run).to add_apt_repository('nginx-amplify')
    end

    it 'installs the agent' do
      expect(chef_run).to upgrade_package('nginx-amplify-agent')
    end

    it 'installs a specific version of the agent' do
      node.set['nginx-amplify']['version'] = '0.23-1'
      expect(chef_run).to install_package('nginx-amplify-agent').with(:version => '0.23-1')
    end

    it 'includes configure and service' do
      expect(chef_run).to include_recipe 'nginx-amplify::configure'
      expect(chef_run).to include_recipe 'nginx-amplify::service'
    end
  end
end
