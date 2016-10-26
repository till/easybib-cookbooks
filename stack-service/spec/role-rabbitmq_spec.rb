require_relative 'spec_helper'

describe 'stack-service::role-rabbitmq' do
  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner)    { ChefSpec::Runner.new(:cookbook_path => cookbook_paths) }
  let(:node)      { runner.node }
  let(:chef_run)  { runner.converge(described_recipe) }

  before do
    node.override['rabbitmq']['erlang_cookie_path'] = File.dirname(__FILE__) << '/erlang_cookie'
  end

  describe 'stack-service::role-rabbitmq' do
    before do
      node.override['logrotate']['global']['/mnt/logs/rabbitmq/*.log'] = {
        :missingok  => true,
        :monthly    => true,
        :create     => '0660 root adm',
        :rotate     => 1,
        :prerotate  => ['rabbitmq start_rotate', 'logger started rabbitmq log rotation'],
        :postrotate => <<-EOF
          rabbitmq end_rotate
          logger completed rabbitmq log rotation
        EOF
      }
    end

    it 'pulls in logrotate' do
      expect(chef_run).to include_recipe('logrotate')
    end

    it 'renders writes the logrotate configuration' do
      expect(chef_run).to render_file('/etc/logrotate.conf')
        .with_content('/mnt/logs/rabbitmq/*.log')
        .with_content('rotate 1')
    end
  end
end
