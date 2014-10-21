require 'chefspec'

describe 'hhvm-fcgi::default' do
  before do
    @shellout = double('shellout')
    @shellout.stub(:live_stream=).with(STDOUT)
    @shellout.stub(:run_command)
    @shellout.stub(:exitstatus)
    @shellout.stub(:error!)
  end

  let (:runner) { ChefSpec::Runner.new }
  let (:chef_run) { runner.converge('hhvm-fcgi::default') }
  let (:node) { runner.node }

  describe 'standard settings' do
    it 'installs hhvm and creates the config files' do
      Mixlib::ShellOut.stub(:new).and_return(@shellout)

      # hhvm-fcgi::apt
      expect(chef_run).to install_apt_package('hhvm')

      # hhvm-fcgi::prepare
      expect(chef_run).to create_directory('/tmp/hhvm')
      expect(chef_run).to create_directory('/var/log/hhvm')
      expect(chef_run).to create_file('/var/log/hhvm/error.log')
      expect(chef_run).to create_template('/etc/init.d/hhvm')

      # hhvm-fcgi::configure
      expect(chef_run).to create_template('/etc/logrotate.d/hhvm')
      expect(chef_run).to create_template('/etc/hhvm/php.ini')
      expect(chef_run).not_to render_file('/etc/hhvm/php.ini')
        .with_content(
          include('[hhvm]')
        )
      expect(chef_run).to render_file('/etc/hhvm/php-fcgi.ini')
        .with_content(
          include('[hhvm]')
        )
      expect(chef_run).to render_file('/etc/hhvm/config.hdf')
        .with_content(
          include('Debug')
        )
    end
  end

  describe 'monit' do
    before do
      node.set['opsworks'] = {}
    end

    it 'is monitored by monit' do
      expect(chef_run).to create_template('/etc/monit/conf.d/hhvm.monitrc')

      expect(chef_run).to render_file('/etc/monit/conf.d/hhvm.monitrc')
        .with_content(
          include("/etc/init.d/#{node['hhvm-fcgi']['service_name']}")
        )
        .with_content(
          include("check process hhvm-server with pidfile \"#{node['hhvm-fcgi']['pid_file']}\"")
        )
    end
  end

  describe 'debug' do
    before do
      node.set['hhvm-fcgi']['build'] = '-dbg'
    end

    it 'installs the debug build of hhvm' do
      expect(chef_run).to install_apt_package('hhvm-dbg')
    end
  end

  describe 'custom port' do
    before do
      node.set['hhvm-fcgi']['listen']['port'] = 31_337
    end

    it 'configures hhvm to listen on 31337' do
      expect(chef_run).to render_file('/etc/hhvm/php-fcgi.ini')
        .with_content(
          include('hhvm.server.port = 31337')
        )
    end
  end

end
