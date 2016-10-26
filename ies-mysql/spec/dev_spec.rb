require 'chefspec'

describe 'ies-mysql::dev' do
  let(:runner) do
    ChefSpec::SoloRunner.new(:log_level => :error)
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  describe 'local/vagrant' do
    it 'it does execute the recipe' do
      expect(chef_run).to create_cookbook_file('/tmp/grant.sql')
      expect(chef_run).to run_execute('open mysql to the world')
    end
  end

  describe 'MySQL 5.7' do
    before do
      node.override['ies-mysql']['version'] = '5.7'
    end

    it 'renders new grants' do
      expect(chef_run).to create_cookbook_file('/tmp/grant57.sql')
    end
  end

  describe 'AWS' do
    before do
      node.override['opsworks'] = {}
    end

    it 'it does not execute the recipe' do
      expect(chef_run).not_to create_cookbook_file('/tmp/grant.sql')
      expect(chef_run).not_to run_execute('open mysql to the world')
    end
  end
end
