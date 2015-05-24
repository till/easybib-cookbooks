require 'chefspec'

describe 'php-fpm::default' do

  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  let(:packages) { 'foo1,foo2,foo3' }

  before do
    stub_command('apt-get install -s php5-easybib-apcu').and_return(1)
    stub_command('apt-get install -s php5-easybib-apc').and_return(0)
    @shellout = double('shellout')
    @shellout.stub(:live_stream=).with(STDOUT)
    @shellout.stub(:run_command)
    @shellout.stub(:exitstatus)
    @shellout.stub(:error!)

    node.set['php-fpm']['packages'] = packages
  end

  it 'installs php5-easybib' do
    Mixlib::ShellOut.stub(:new).and_return(@shellout)

    expect(chef_run).to install_package(packages.split(','))
  end

  # it "creates symlinks to all the binaries" do
  #  Mixlib::ShellOut.stub(:new).and_return(@shellout)
  #  ["pear", "peardev", "pecl", "phar", "phar.phar", "php-config", "phpize"].each do |bin|
  #    expect(chef_run).to create_link("/usr/local/bin/#{bin}")
  #  end
  # end
end
