require_relative 'spec_helper.rb'

describe 'ies-letsencrypt::setup' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  describe 'setup' do
    before do
      node.set['sysop_email'] = 'bofh@example.org'
    end

    it 'creates the cli.ini' do
      expect(chef_run).to create_template('/etc/letsencrypt/cli.ini')
    end
  end
end
