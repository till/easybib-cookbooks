require_relative 'spec_helper.rb'

describe 'ies-gearmand::service' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  describe 'standard flow' do
    it 'installs the config for systemd' do
      expect(chef_run).to create_directory('/etc/systemd/system/gearman-job-server.service.d')
      expect(chef_run).to create_cookbook_file('/etc/systemd/system/gearman-job-server.service.d/override.conf')
    end

    it 'installs the config for upstart' do
      expect(chef_run).to create_cookbook_file('/etc/init/gearman-job-server.override')
    end

    it 'notifies systemd to daemon-reload' do
      resource = chef_run.cookbook_file('/etc/systemd/system/gearman-job-server.service.d/override.conf')
      expect(resource).to notify('execute[systemctl daemon-reload]')
    end
  end
end
