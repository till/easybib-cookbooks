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

  it 'downloads the install-ruby archive' do
    expect(chef_run).to create_remote_file("#{file_cache_path}/ruby-install-#{ruby_install_version}.tar.gz")
  end

  it 'unpacks ruby-install archive' do
    expect(chef_run).to run_execute('unpack ruby-install archive')
  end

  it 'installs ruby-install' do
    expect(chef_run).to run_execute('install ruby-2.2.3')
  end

  it 'creates gemrc' do
    expect(chef_run).to create_cookbook_file('/root/.gemrc')
  end

  it 'installs bundler' do
    expect(chef_run).to install_gem_package('bundler')
  end
end
