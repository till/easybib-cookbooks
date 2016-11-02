require_relative 'spec_helper'

describe 'stack-service::role-statsd' do

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

  let(:chef_run) { runner.converge(described_recipe) }

  describe 'stack-service::role-statsd' do
    before do
      node.override['easybib'] = {
        'cluster_name' => 'vagrant-test'
      }
    end
    it 'includes all recipes' do
      expect(chef_run).to include_recipe('ies::role-generic')
      expect(chef_run).to include_recipe('nodejs')
      expect(chef_run).to include_recipe('statsd')
    end
  end
end
