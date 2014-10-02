require_relative 'spec_helper'

describe 'packetbeat agent' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end
  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge('packetbeat::interface') }
  let(:node)     { runner.node }

  describe 'run with password' do
    before do
      node.set['opsworks']['instance']['layers'] = ['qa']
      node.set['packetbeat']['config']['elasticsearch'] = 'http://user:pass@127.0.0.1:9200'
      node.set['deploy']['packetbeat'] = {
        'document_root' => 'root',
        'domains' => [],
        'deploy_to' => '/path'
      }
    end

    it 'does create config.js' do
      expect(chef_run).to render_file('/path/current/root/config.js')
        .with_content(
          include('elasticsearch: {server: "http://127.0.0.1:9200"')
        )
    end

    it 'does create htpasswd file' do
      expect(chef_run).to render_file('/etc/nginx/packetbeat.htpasswd')
        .with_content(
          include('user:usGhvISzyaLuU')
        )
    end

  end

end
