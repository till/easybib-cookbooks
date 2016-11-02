require_relative 'spec_helper'

describe 'ies-sinopia::default' do
  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'includes all required recipes' do
    expect(chef_run).to include_recipe('ies-sinopia::default')
    expect(chef_run).to include_recipe('sinopia::nodejs')
    expect(chef_run).to include_recipe('sinopia::sinopia')
  end
end
