require 'chefspec'

describe 'php-fpm::default' do
  before do
    stub_command("apt-get install -s php5-easybib-apcu").and_return(1)
    stub_command("apt-get install -s php5-easybib-apc").and_return(0)
  end

  let (:chef_run) do
    ChefSpec::Runner.new.converge('php-fpm::default')
  end

  it "installs php5-easybib" do
    expect(chef_run).to install_package('php5-easybib')
  end

  it "creates symlinks to all the binaries" do
    ["pear", "peardev", "pecl", "phar", "phar.phar", "php-config", "phpize"].each do |bin|
      expect(chef_run).to create_link("/usr/local/bin/#{bin}")
    end
  end
end
