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
      node.set['ies-letsencrypt']['certbot']['bin']  = '/opt/le/certbot'
      node.set['ies-letsencrypt']['certbot']['cron'] = '/opt/le/cron'
      node.set['ies-letsencrypt']['certbot']['port'] = 31_337
      node.set['ies-letsencrypt']['ssl_dir']         = '/home/till/ssl'
    end

    it 'has an initial setup command to get certificates' do
      expect(chef_run).not_to run_execute('certbot_setup')
    end

    it 'installs the cronjob wrapper' do
      expect(chef_run).to render_file('/opt/le/cron')
      expect(chef_run).to render_file('/opt/le/cron')
        .with_content(include('/opt/le/certbot'))
    end

    it 'installs the auto-renewal cronjob' do
      expect(chef_run).to create_cron_d('certbot_renewal')
    end

    it 'uses the correct command' do
      resource = chef_run.cron_d('certbot_renewal')
      cmd      = resource.command

      expect(cmd).to start_with('/opt/le/cron')
    end

    it 'uses the correct ssl dir' do
      expect(chef_run).to render_file('/opt/le/cron')
        .with_content(
          include('COMBINED="/home/till/ssl/cert.combined.pem"')
        )
    end
  end
end
