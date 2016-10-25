require 'chefspec'

describe 'php-fpm::default' do
  let(:runner) do
    ChefSpec::Runner.new(
      :platform => 'ubuntu',
      :version => '16.04'
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

  describe 'php.ini refactoring' do
    before do
      node.override['php-fpm']['packages'] = 'php5-easybib-soap,php5-easybib-tidy'
    end

    it 'includes module recipes for soap & tidy' do
      expect(chef_run).to include_recipe 'php::module-soap'
      expect(chef_run).to include_recipe 'php::module-tidy'
    end

    it 'does not install soap & tidy' do
      expect(chef_run).not_to install_php_ppa_package('soap')
      expect(chef_run).not_to install_php_ppa_package('tidy')
    end

    it 'sets up configuration for soap & tidy' do
      expect(chef_run).to generate_php_config('soap')
      expect(chef_run).to generate_php_config('tidy')
    end
  end

  # it "creates symlinks to all the binaries" do
  #  Mixlib::ShellOut.stub(:new).and_return(@shellout)
  #  ["pear", "peardev", "pecl", "phar", "phar.phar", "php-config", "phpize"].each do |bin|
  #    expect(chef_run).to create_link("/usr/local/bin/#{bin}")
  #  end
  # end
end
