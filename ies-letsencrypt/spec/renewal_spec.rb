require_relative 'spec_helper.rb'

describe 'ies-letsencrypt::renewal' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  describe 'no domains configured' do
    it 'does not install the auto-renewal cronjob' do
      expect(chef_run).not_to create_cron_d('certbot_renewal')
    end
  end

  describe 'domains configured' do
    before do
      node.set['ies-letsencrypt']['domains'] = [
        'example.org',
        'secure.example.org'
      ]
      node.set['ies-letsencrypt']['certbot']['bin'] = '/opt/le/certbot'
      node.set['ies-letsencrypt']['certbot']['port'] = 31_337
    end

    it 'installs the auto-renewal cronjob' do
      expect(chef_run).to create_cron_d('certbot_renewal')
    end

    it 'uses the correct port and all domains' do
      resource = chef_run.cron_d('certbot_renewal')
      cmd = resource.command

      expect(cmd).to start_with('/opt/le/certbot')
      expect(cmd).to include('--http-01-port 31337')
    end
  end
end
