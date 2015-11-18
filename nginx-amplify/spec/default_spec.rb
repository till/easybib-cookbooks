require_relative 'spec_helper'

describe 'nginx-amplify::default' do

  let(:runner) do
    ChefSpec::Runner.new
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'default' do
    it 'installs the agent' do
      expect(chef_run).to add_apt_repository('nginx-amplify')
      expect(chef_run).to install_package('nginx-amplify-agent')
    end

    it 'includes configure and service' do
      expect(chef_run).to include_recipe 'nginx-amplify::configure'
      expect(chef_run).to include_recipe 'nginx-amplify::service'
    end
  end
end
