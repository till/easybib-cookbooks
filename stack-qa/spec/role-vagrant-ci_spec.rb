require 'chefspec'

describe 'stack-qa::role-vagrant-ci' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :platform => 'ubuntu',
      :version => '14.04'
    )
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'role-vagrant-ci' do
    before do
      Dir.stub(:home) { '/root' }

      # don't deploy
      node.set['deploy'] = {}
    end

    it 'includes the desired cookbooks' do
      expect(chef_run).to include_recipe('ies::role-generic')
      expect(chef_run).to include_recipe('virtualbox')
      expect(chef_run).to include_recipe('vagrant')
      expect(chef_run).to include_recipe('stack-qa::deploy-vagrant-ci')
    end
  end
end
