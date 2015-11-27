require_relative 'spec_helper.rb'

describe 'php::module-mysqli' do

  let(:runner)    { ChefSpec::Runner.new }
  let(:chef_run)  { runner.converge(described_recipe) }
  let(:node)      { runner.node }

  before do
    node.override['php']['ppa']['package_prefix'] = 'php-ppa-prefix'
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('php::dependencies-ppa')
  end

  it 'installs the core php package' do
    expect(chef_run).to install_package('php-ppa-prefix')
  end

  it 'configures the extension' do
    expect(chef_run).to generate_php_config('mysqli')
      .with(:config => node['php-mysqli']['settings'])
  end
end
