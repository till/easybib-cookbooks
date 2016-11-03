require_relative 'spec_helper'

describe 'ies-sinopia::users' do
  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'creates the sinopia user' do
    expect(chef_run).to create_user('sinopia').with(
      :shell => '/bin/nologin',
      :system => true,
      :manage_home => true
    )
  end
end
