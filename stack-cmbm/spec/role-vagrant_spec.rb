require_relative 'spec_helper.rb'

describe 'stack-cmbm::role-vagrant' do

  let(:runner)    { ChefSpec::Runner.new }
  let(:chef_run)  { runner.converge(described_recipe) }
  let(:node)      { runner.node }

  before do
    node.set[:vagrant][:applications] = {
      :cmbm => {
        :app_root_location => '/vagrant_cmbm',
        :doc_root_location => '/vagrant_cmbm/public',
        :default_router => '',
        :domain_name => 'cmbm.bib'
      }
    }
  end

  it 'installs all gem dependencies' do
    expect(chef_run).to run_execute('install gems')
  end

  it 'runs app setup' do
    expect(chef_run).to run_execute('setup app')
  end

  it 'installs the zshrc' do
    expect(chef_run).to create_cookbook_file('/home/vagrant/.zshrc')
  end
end
