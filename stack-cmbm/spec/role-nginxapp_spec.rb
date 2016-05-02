require_relative 'spec_helper.rb'

describe 'stack-cmbm::role-nginxapp' do

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

  it 'pulls in all package dependencies' do
    [
      'libxml2', 'libmysqlclient-dev', 'autoconf', 'bison', 'build-essential', 'libssl-dev', 'libyaml-dev',
      'libreadline6-dev', 'zlib1g-dev', 'libncurses5-dev', 'libffi-dev', 'libgdbm3', 'libgdbm-dev', 'libreadline-dev',
      'qt5-default', 'libqt5webkit5-dev', 'gstreamer1.0-plugins-base', 'gstreamer1.0-tools'
    ].each do |p|
      expect(chef_run).to install_package(p)
    end
  end

  it 'includes all required recipes' do
    expect(chef_run).to include_recipe('ies::role-generic')
    expect(chef_run).to include_recipe('nodejs')
    expect(chef_run).to include_recipe('redis')
    expect(chef_run).to include_recipe('stack-cmbm::deploy-ruby')
    expect(chef_run).to include_recipe('stack-cmbm::deploy-puma')
  end
end
