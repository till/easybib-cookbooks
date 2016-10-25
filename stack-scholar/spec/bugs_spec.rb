require 'chefspec'
require 'json'

describe 'fixtures::brokenapps' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => %w(easybib_deploy_manager)
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:fixtures) { "#{File.dirname(__FILE__)}/fixtures" }

  before do
    node.set['opsworks']['stack']['name']      = 'stack-chefspec'
    node.set['opsworks']['instance']['layers'] = ['node-chefspec']
  end

  describe 'broken apps' do
    before do
      node.set['deploy']                         = JSON.parse(File.read("#{fixtures}/deploy.json"))
      node.set['stack-chefspec']['applications'] = JSON.parse(File.read("#{fixtures}/brokenapps.json"))
    end

    it 'chef throws an exception' do
      expect { chef_run }.to raise_error(RuntimeError)
    end
  end
end
