require_relative 'spec_helper'

describe 'nginx-amplify::configure' do

  let(:runner) do
    ChefSpec::Runner.new
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'api_key' do
    before do
      node.set['nginx-amplify']['api_key'] = 'super-secret'
    end

    it 'installs agent.conf' do
      expect(chef_run).to render_file('/etc/amplify-agent/agent.conf')
    end

    it 'reloads amplify-agent after agent.conf is installed' do
      tpl = chef_run.template('/etc/amplify-agent/agent.conf')
      expect(tpl).to notify('service[amplify-agent]').to(:reload)
    end

    it 'includes service' do
      expect(chef_run).to include_recipe 'nginx-amplify::service'
    end
  end

  describe 'without api_key (default)' do
    it 'does not install agent.conf' do
      expect(chef_run).not_to render_file('/etc/amplify-agent/agent.conf')
    end
  end
end
