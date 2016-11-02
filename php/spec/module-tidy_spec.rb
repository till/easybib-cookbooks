require_relative 'spec_helper.rb'

describe 'php::module-tidy' do
  let(:runner) { ChefSpec::Runner.new }

  let(:node) { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }

  before do
    node.override['php']['ppa']['package_prefix'] = 'php5.6'
    node.override['php-fpm']['tmpdir'] = '/tmp/chefspec/php'
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('php::dependencies-ppa')
  end

  it 'adds php-fpm service definition' do
    expect(chef_run).to include_recipe('php-fpm::service')
  end

  it 'installs the tidy extension' do
    expect(chef_run).to install_php_ppa_package('tidy')
  end

  it 'creates tidy-settings.ini' do
    expect(chef_run).to generate_php_config('tidy')
  end
end
