require_relative 'spec_helper.rb'

describe 'php::dependencies-ppa' do

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('apt::ppa')
    expect(chef_run).to include_recipe('apt::easybib')
  end
end
