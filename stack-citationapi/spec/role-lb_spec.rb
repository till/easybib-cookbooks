require_relative 'spec_helper'

describe 'stack-citationapi::role-lb' do

  let(:runner)      { ChefSpec::Runner.new }
  let(:chef_run)    { runner.converge(described_recipe) }
  let(:node)        { runner.node }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['instance']['layers'] = ['bibapi']
    node.set['opsworks']['instance']['hostname'] = 'host'
    node.set['opsworks']['instance']['ip'] = '127.0.0.1'
    node.set['deploy']['easybib_api'] = {
      :deploy_to => '/srv/www/bibapi',
      :document_root => 'public'
    }
  end

  it 'pulls in all required recipes' do
    %w(
      ies::role-generic
      haproxy::ctl
      haproxy::hatop
      haproxy::logs
    ).each do |recipe|
      expect(chef_run).to include_recipe(recipe)
    end
  end
end
