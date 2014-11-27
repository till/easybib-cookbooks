require_relative 'spec_helper'

describe 'smokeping_default' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths
    )
  end

  let(:node) { runner.node }

  let(:chef_run) { runner.converge('smokeping::default') }

  describe 'smokeping installation' do
    it 'installs required ubuntu packages' do
      expect(chef_run).to install_package('smokeping')
      expect(chef_run).to install_package('fping')
      expect(chef_run).to install_package('tcptraceroute')
    end
    it 'does include service definition and configuration' do
      expect(chef_run).to include_recipe('smokeping::configure')
      expect(chef_run).to include_recipe('smokeping::service')
    end
    it 'does include nginx' do
      expect(chef_run).to include_recipe('nginx-app::server')
    end
    it 'does not include tcpping or hccping' do
      expect(chef_run).not_to include_recipe('smokeping::tcpping')
      expect(chef_run).not_to include_recipe('smokeping::hping')
    end
  end

  describe 'smokeping installation with probes set in config' do
    before do
      node.set['smokeping']['probes']['tcpping'] = { 'binary' => '/whatever' }
      node.set['smokeping']['probes']['hping']   = { 'binary' => '/whatever_else' }
    end
    it 'does include hping and tcpping recipes' do
      expect(chef_run).to include_recipe('smokeping::tcpping')
      expect(chef_run).to include_recipe('smokeping::hping')
    end
  end

end
