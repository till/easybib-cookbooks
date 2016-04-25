require 'chefspec'
require_relative 'spec_helper.rb'

describe 'stack-cmbm::deploy-ruby' do
  let(:runner)                { ChefSpec::Runner.new }
  let(:chef_run)              { runner.converge(described_recipe) }
  let(:node)                  { runner.node }
  let(:ruby_version)          { node['ruby']['version'] }
  let(:ruby_install_version)  { node['ruby_install']['version'] }
  let(:file_cache_path)       { Chef::Config['file_cache_path'] }

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
end
