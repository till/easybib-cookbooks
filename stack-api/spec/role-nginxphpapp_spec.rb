require_relative 'spec_helper'

describe 'stack-api::role-nginxphpapp' do
  let(:runner)       { ChefSpec::Runner.new }
  let(:chef_run)     { runner.converge(described_recipe) }
  let(:node)         { runner.node }

  before do
    node.set['opsworks']['stack']['name']        = 'Stack'
    node.set['opsworks']['instance']['layers']   = ['silex']
    node.set['opsworks']['instance']['hostname'] = 'host'
    node.set['opsworks']['instance']['ip']       = '127.0.0.1'
    node.set['deploy']['sitescraper']            = {
      :deploy_to => '/srv/www/silex',
      :document_root => 'public'
    }
  end

  it 'pulls in ies::role-phpapp' do
    expect(chef_run).to include_recipe('ies::role-phpapp')
  end

  it 'deploys silex' do
    expect(chef_run).to include_recipe('easybib-deploy::silex')
  end
end
