require_relative 'spec_helper.rb'

describe 'stack-cmbm::role-vagrant' do

  let(:runner)    { ChefSpec::Runner.new }
  let(:chef_run)  { runner.converge(described_recipe) }
  let(:node)      { runner.node }

  before do
    node.override[:vagrant][:applications] = {
      :cmbm => {
        :app_root_location => '/vagrant_cmbm',
        :doc_root_location => '/vagrant_cmbm/public'
      }
    }
  end

  it 'pulls in all required recipes' do
    expect(chef_run).to include_recipe('ies::role-generic')
    expect(chef_run).to include_recipe('ies-mysql')
    expect(chef_run).to include_recipe('ies-mysql::dev')
    expect(chef_run).to include_recipe('ies-zsh')
    expect(chef_run).to include_recipe('redis')
    expect(chef_run).to include_recipe('stack-cmbm::role-nginxapp')
    expect(chef_run).to include_recipe('stack-cmbm::deploy-vagrant')
  end

  it 'installs all packages required extra on the vagrant box' do
    expect(chef_run).to install_package('xvfb')
  end
end
