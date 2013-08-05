require 'chefspec'

describe 'php-fpm::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge('php-fpm::default') }
  it "installs php5-easybib" do
    expect(chef_run).to install_package 'php5-easybib'
  end

  it "creates symlinks to all the binaries" do
    ["pear", "peardev", "pecl", "phar", "phar.phar", "php-config", "phpize"].each do |bin|
      expect(chef_run).to create_link "/usr/local/bin/#{bin}"
    end
  end
end
