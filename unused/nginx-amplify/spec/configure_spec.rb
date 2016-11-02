require_relative 'spec_helper'

describe 'nginx-amplify::configure' do

  let(:runner) do
    ChefSpec::Runner.new
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:agent_conf) { '/etc/amplify-agent/agent.conf' }

  before do
    Mixlib::ShellOut.stub(:new).and_return(
      double(
        :run_command => '/usr/bin/nginx-amplify-uuid-helper.py',
        :error! => nil,
        :stdout => 'node-uuid',
        :stderr => ''
      )
    )
  end

  describe 'api_key' do
    before do
      node.override['nginx-amplify']['api_key'] = 'super-secret'
      node.override['nginx-amplify']['hostname'] = 'box.example.org'
    end

    it 'installs the uuid helper' do
      expect(chef_run).to create_cookbook_file('/usr/bin/nginx-amplify-uuid-helper.py')
    end

    it 'installs agent.conf' do
      expect(chef_run).to create_template(agent_conf)
        .with_variables(
          :api_key => 'super-secret',
          :hostname => 'box.example.org',
          :uuid => 'node-uuid'
        )
    end

    it 'reloads amplify-agent after agent.conf is installed' do
      tpl = chef_run.template(agent_conf)
      expect(tpl).to notify('service[amplify-agent]').to(:reload)
    end

    it 'includes service' do
      expect(chef_run).to include_recipe 'nginx-amplify::service'
    end

    it 'sets the correct hostname' do
      expect(chef_run).to render_file(agent_conf)
        .with_content('hostname = box.example.org')
    end
  end

  describe 'without api_key (default)' do
    it 'does not install agent.conf' do
      expect(chef_run).not_to render_file(agent_conf)
    end
  end
end
