require 'chefspec'
require_relative 'spec_helper.rb'

describe 'ies-zsh::install' do
  let(:runner)        { ChefSpec::Runner.new }
  let(:chef_run)      { runner.converge(described_recipe) }
  let(:node)          { runner.node }

  it 'installs zsh' do
    expect(chef_run).to install_package('zsh')
  end

  it 'deploys the zprofile' do
    expect(chef_run).to create_cookbook_file('/etc/zsh/zprofile')
  end
end
