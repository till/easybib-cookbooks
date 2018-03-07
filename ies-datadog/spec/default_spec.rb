require_relative 'spec_helper'

describe 'ies-datadog::default' do
  let(:runner) do
    ChefSpec::Runner.new do |node|
      node.override[:opsworks][:stack][:name] = 'chefspec'
      node.override[:opsworks][:instance][:region][:id] = 'local'
      node.override[:opsworks][:layers][:nginxphpapp][:instances] = {}
      node.override[:opsworks][:layers][:app1][:instances] = {}
      node.override[:opsworks][:layers][:app2][:instances] = {}
      node.override[:datadog][:api_key] = '40404040404040404040404040404040'
    end
  end
  let(:chef_run) { runner.converge('ies-datadog::default') }
  let(:node) { runner.node }

  describe 'standard flow without haproxy' do
    before do
      stub_command('pgrep datadog-agent').and_return(true)
    end

    it 'does create and configure datadog.conf' do
      expect(chef_run).to create_template('/etc/dd-agent/datadog.conf').with(
        :user => 'dd-agent',
        :group => 'dd-agent',
        :mode => 0640
      )

      expected = [
        'api_key: 40404040404040404040404040404040',
        'hostname: playground-chefspec_lb'
      ]

      expected.each do |content|
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf').with_content(content)
      end
    end

    it 'does not create or configure haproxy.yaml' do
      expect(chef_run).to_not create_template('/etc/dd-agent/conf.d/haproxy.yaml')
    end
  end
end
