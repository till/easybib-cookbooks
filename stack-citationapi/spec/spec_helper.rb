require 'chefspec'
RSpec.configure do |c|
  c.color = true
  c.platform = 'ubuntu'
  c.version = '14.04'
  c.log_level = :warn
  c.alias_example_group_to :describe_recipe, :type => :recipe
end

RSpec.shared_context 'recipe tests', :type => :recipe do
  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }
  before do
    node.set['opsworks']['stack']['name'] = 'Some Stack'
    node.set['opsworks']['instance'] = {
      'layers' => ['ze layer'],
      'hostname' => 'hostname',
      'ip' => '127.0.0.1'
    }
    node.set['deploy'] = {}
  end
end
