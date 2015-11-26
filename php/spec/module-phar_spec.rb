require_relative 'spec_helper.rb'

describe 'php::module-phar' do

  let(:runner)    { ChefSpec::Runner.new }
  let(:chef_run)  { runner.converge(described_recipe) }
  let(:node)      { runner.node }

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('apt::easybib')
    expect(chef_run).to include_recipe('apt::ppa')
  end

  it 'installs and configures the extension' do
    expect(chef_run).to install_php_ppa_package('phar')
      .with(:config => node['php-phar']['settings'])
  end
end
