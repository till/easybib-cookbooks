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
        :domain_name => 'cmbm.bib',
        :ruby_version => '2.2.3'
      }
    }
  end

  it 'includes all required recipes' do
    expect(chef_run).to include_recipe('ies-mysql')
    expect(chef_run).to include_recipe('ies-mysql::dev')
    expect(chef_run).to include_recipe('stack-cmbm::role-nginxapp')
  end
end
