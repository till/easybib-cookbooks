require 'chefspec'

describe 'hhvm-fcgi::default' do
  before do
    @shellout = double('shellout')
    @shellout.stub(:live_stream=).with(STDOUT)
    @shellout.stub(:run_command)
    @shellout.stub(:exitstatus)
    @shellout.stub(:error!)
  end

  let (:chef_run) do
    ChefSpec::Runner.new.converge('hhvm-fcgi::default')
  end

  it "creates the config files" do
    Mixlib::ShellOut.stub(:new).and_return(@shellout)

    # hhvm-fcgi::prepare
    expect(chef_run).to create_directory('/tmp/hhvm')
    expect(chef_run).to create_directory('/var/log/hhvm')
    expect(chef_run).to create_file('/var/log/hhvm/error.log')
    expect(chef_run).to create_template('/etc/init.d/hhvm')

    # hhvm-fcgi::configure
    expect(chef_run).to create_template('/etc/logrotate.d/hhvm')
    expect(chef_run).to create_template('/etc/hhvm/php.ini')
    expect(chef_run).to create_template('/etc/hhvm/php-fcgi.ini')
    expect(chef_run).to create_template('/etc/hhvm/config.hdf')
  end

end
