require 'chefspec'

describe 'php-fpm::default' do
  let(:runner) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '14.04'
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  before do
    stub_command('apt-get install -s php5-easybib-apcu').and_return(1)
    stub_command('apt-get install -s php5-easybib-apc').and_return(0)
    @shellout = double('shellout')
    @shellout.stub(:live_stream=).with(STDOUT)
    @shellout.stub(:run_command)
    @shellout.stub(:exitstatus)
    @shellout.stub(:error!)
  end

  it 'installs php5-easybib' do
    Mixlib::ShellOut.stub(:new).and_return(@shellout)
    expect(chef_run).to install_package('php5-easybib')
  end

  # it "creates symlinks to all the binaries" do
  #  Mixlib::ShellOut.stub(:new).and_return(@shellout)
  #  ["pear", "peardev", "pecl", "phar", "phar.phar", "php-config", "phpize"].each do |bin|
  #    expect(chef_run).to create_link("/usr/local/bin/#{bin}")
  #  end
  # end
end
