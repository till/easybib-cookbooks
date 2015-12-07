require_relative 'spec_helper.rb'

describe 'stack-qa::role-vagrant-ci' do
  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'role-vagrant-ci' do
    before do
      node.set['deploy'] = []
    end
    it 'includes the desired cookbooks' do
      expect(chef_run).to include_recipe('ies::role-generic')
      expect(chef_run).to include_recipe('virtualbox')
      expect(chef_run).to include_recipe('vagrant')
      expect(chef_run).to include_recipe('stack-qa::deploy-vagrant-ci')
    end
  end
end
