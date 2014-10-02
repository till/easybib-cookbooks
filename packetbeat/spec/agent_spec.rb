require_relative 'spec_helper'

describe 'packetbeat agent' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end
  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths
    )
  end
  let(:chef_run) { runner.converge('packetbeat::agent') }
  let(:node)     { runner.node }

  describe 'standardrun' do
    before do
      node.set['packetbeat']['agent_deb'] = 'https://github.com/packetbeat/packetbeat/releases/download/v0.3.3/packetbeat_0.3.3-1_amd64.deb'
      node.set['opsworks']['instance']['hostname'] = 'some-host'
      node.set['opsworks']['stack']['name'] = 'some-stack'
    end

    it 'does download the packetbeat package' do
      expect(chef_run).to create_remote_file('/var/chef/cache/packetbeat_0.3.3-1_amd64.deb')
    end

    it 'does install the packetbeat package' do
      expect(chef_run).to install_dpkg_package('packetbeat')
    end

    it 'does create a config' do
      expect(chef_run).to render_file('/etc/packetbeat.conf')
        .with_content(
          include('procs.monitored.nginx')
        )
    end

  end

end
