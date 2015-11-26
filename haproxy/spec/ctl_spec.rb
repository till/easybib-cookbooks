require_relative 'spec_helper.rb'

describe 'haproxy::ctl' do
  let(:runner) do
    ChefSpec::Runner.new do |node|
      node.set[:opsworks][:layers][:nginxphpapp][:instances] = {}
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }
  let(:ctl_path) { node['haproxy']['ctl']['base_path'] }

  describe 'standard settings' do
    before do
      node.set['opsworks']['stack']['name'] = 'Amazing Stack'
      node.set['haproxy']['ctl']['statsd']['host'] = 'foo.example.com'
      node.set['haproxy']['ctl']['statsd']['port'] = '23'
    end

    it 'installs haproxyctl' do
      expect(chef_run).to create_directory(ctl_path).with(
        :user => 'root',
        :group => 'root',
        :mode => '0755'
      )

      expect(chef_run).to sync_git("#{ctl_path}/haproxyctl").with(
        :repository => 'git://github.com/easybiblabs/haproxyctl.git',
        :reference => node['haproxy']['ctl']['version']
      )

      expect(chef_run).to create_link('/etc/init.d/haproxyctl')
    end

    it 'sets up statsd reporting' do
      expect(chef_run).to create_directory('/etc/haproxy/haproxyctl').with(
        :user => 'root'
      )

      expect(chef_run).to render_file('/etc/haproxy/haproxyctl/instance-name')
        .with_content('playground.amazing_stack_lb')
    end

    it 'creates statsd reporting cronjob' do
      expect(chef_run).to create_cron_d('haproxyctl_statsd')
        .with(
          :command => "/bin/bash -c '/usr/local/share/haproxyctl/bin/haproxyctl statsd > /dev/udp/foo.example.com/23'"
        )
    end
  end
end
