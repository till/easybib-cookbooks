require 'chefspec'
require_relative 'spec_helper.rb'

describe 'stack-cmbm::deploy-puma' do
  let(:runner)        { ChefSpec::Runner.new }
  let(:chef_run)      { runner.converge(described_recipe) }
  let(:node)          { runner.node }
  let(:template_name) { '/etc/puma.conf' }
  let(:rundir)        { '/var/run/puma' }

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

  it 'creates the puma.conf' do
    expect(chef_run).to create_template(template_name)
      .with(
        :path => template_name,
        :source => 'puma.conf.erb'
      )
  end

  it 'creates the run-dir' do
    expect(chef_run).to create_directory(rundir)
  end
end
