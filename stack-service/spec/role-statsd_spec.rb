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

  describe 'on localhost' do
    it 'includes nodejs' do
      expect(chef_run).to include_recipe('nodejs')
      expect(chef_run).to include_recipe('statsd')
    end
  end

  describe 'on OpsWorks' do
    before do
      node.set['opsworks'] = {
        'instance' => {
          'layers' => [
            'mothership',
            'borg',
            'muddership',
            'statsd'
          ]
        }
      }
      node.set['deploy'] = [
        'statsd' => {
          'user' => 'till',
          'home' => '/home/till',
          'group' => 'till'
        }
      ]
    end

    it 'does not include nodejs' do
      expect(chef_run).not_to include_recipe('nodejs')
    end
  end
end
