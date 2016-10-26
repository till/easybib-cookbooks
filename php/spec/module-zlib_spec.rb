require_relative 'spec_helper.rb'

describe 'php::module-zlib' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('php::dependencies-ppa')
  end

  it 'installs and configures the extension' do
    expect(chef_run).to install_php_ppa_package('zlib')
  end

end
