require 'spec_helper'

describe 'papertrail::default' do
  let(:runner)   { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }
  let(:default_configfile) { '/etc/rsyslog.d/65-papertrail.conf' }
  let(:watchfiles_configfile) { '/etc/rsyslog.d/60-watch-files.conf' }
  let(:fixhost_configfile) { '/etc/rsyslog.d/61-fixhostnames.conf' }

  it 'require rsyslog' do
    expect(chef_run).to include_recipe 'rsyslog'
  end

  it 'uses attributes to generate configuration' do
    expect(chef_run).to render_file(default_configfile)
      .with_content('$ActionResumeRetryCount -1')
    expect(chef_run).to render_file(default_configfile)
      .with_content('$ActionQueueMaxDiskSpace 100M')
    expect(chef_run).to render_file(default_configfile)
      .with_content('$ActionQueueSize 100000')
    expect(chef_run).to render_file(default_configfile)
      .with_content('$ActionQueueFileName papertrailqueue')
  end

  it 'does not create watch files conf' do
    expect(chef_run).not_to render_file(watchfiles_configfile)
  end

  it 'does not create fix hostnames conf' do
    expect(chef_run).not_to render_file(fixhost_configfile)
  end

  it 'does not add the fixhostname cmd to the log target' do
    expect(chef_run).not_to render_file(default_configfile)
      .with_content(';FixHostname')
  end

  describe 'with watchfiles added' do
    before do
      node.set['papertrail']['watch_files'] = { 'test/file/name.jpg' => 'test_file' }
    end

    it 'uses the basename of the filename as the suffix for state file name' do
      expect(chef_run).to render_file(watchfiles_configfile)
        .with_content('$InputFileName test/file/name.jpg')
      expect(chef_run).to render_file(watchfiles_configfile)
        .with_content('$InputFileTag test_file')
      expect(chef_run).to render_file(watchfiles_configfile)
        .with_content('$InputFileStateFile state_file_name_test_file')
    end
  end

  describe 'with hostname set' do
    before do
      # no good idea how to mock something to test hostname_cmd.. :/
      node.set['papertrail']['hostname_name'] = 'some.host.tld'
    end

    it 'creates the fix host template' do
      expect(chef_run).to render_file(fixhost_configfile)
        .with_content('FixHostname,"<%pri%>%timestamp% some.host.tld %syslogtag%')
    end

    it 'sets the fix host template in papertrail conf' do
      expect(chef_run).to render_file(default_configfile)
        .with_content(';FixHostname')
    end
  end
end
