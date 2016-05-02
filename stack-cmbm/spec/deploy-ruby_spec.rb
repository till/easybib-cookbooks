require 'chefspec'
require_relative 'spec_helper.rb'

describe 'stack-cmbm::deploy-ruby' do
  let(:runner)                { ChefSpec::Runner.new }
  let(:chef_run)              { runner.converge(described_recipe) }
  let(:node)                  { runner.node }
  let(:ruby_version)          { node['ruby']['version'] }
  let(:ruby_install_version)  { node['ruby_install']['version'] }
  let(:file_cache_path)       { Chef::Config['file_cache_path'] }
  let(:user)                  { 'vagrant' }
  let(:home)                  { '/home/vagrant' }
  let(:rbenv_home)            { "#{home}/.rbenv" }

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

  it 'syncs the git repository for rbenv' do
    expect(chef_run).to sync_git(rbenv_home)
  end

  it 'syncs the git repository of ruby-build' do
    expect(chef_run).to create_directory("#{rbenv_home}/plugins")
    expect(chef_run).to sync_git("#{rbenv_home}/plugins/ruby-build")
  end

  it 'creates the rc-files with rbenv requirements' do
    expect(chef_run).to render_file("#{home}/.bashrc")
      .with_content('export PATH=~/.rbenv/bin:$PATH')
      .with_content('eval "$(rbenv init -)"')
    expect(chef_run).to render_file("#{home}/.zshrc")
      .with_content('export PATH=~/.rbenv/bin:$PATH')
      .with_content('eval "$(rbenv init -)"')
  end

  it 'installs all required ruby-versions' do
    expect(chef_run).to run_execute('install ruby-version for opsworks-agent')
    expect(chef_run).to run_execute('install ruby-version for CMBM')
  end

  it 'sets the ruby-version required by OpsWorks as global default' do
    expect(chef_run).to run_execute('set ruby-version for OpsWorks as global default')
  end
end
