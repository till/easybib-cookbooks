require_relative 'spec_helper.rb'

describe 'ies-letsencrypt::certbot' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  describe 'standard settings' do
    before do
      node.override['ies-letsencrypt']['certbot']['bin'] = '/foo/cb'
    end

    it 'installs certbot-auto' do
      expect(chef_run).to create_cookbook_file('/foo/cb')
    end

    it 'updates certbot-auto' do
      expect(chef_run).to run_execute('certbot_update')
    end
  end
end
