require_relative 'spec_helper.rb'

describe 'stack-citationapi::role-citation-pdf-api' do
  let(:runner)      { ChefSpec::Runner.new }
  let(:chef_run)    { runner.converge(described_recipe) }
  let(:node)        { runner.node }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['instance']['layers'] = ['pdf_autocite']
    node.set['opsworks']['instance']['hostname'] = 'host'
    node.set['opsworks']['instance']['ip'] = '127.0.0.1'
    node.set['deploy']['pdf_autocite'] = {
      'deploy_to' => '/srv/www/pdf_autocite',
      'document_root' => 'public',
      'domains' => ['domain']
    }
  end

  it 'pulls in all required recipes' do
    expect(chef_run).to include_recipe('stack-citationapi::role-phpapp')
    expect(chef_run).to include_recipe('gearmand')
    expect(chef_run).to include_recipe('php::module-poppler-pdf')
    expect(chef_run).to include_recipe('php::module-posix')
    expect(chef_run).to include_recipe('stack-citationapi::deploy-citationapi')
  end
end
