require_relative 'spec_helper.rb'

describe 'stack-citationapi::role-citation-pdf-api' do
  let(:runner)      { ChefSpec::Runner.new }
  let(:chef_run)    { runner.converge(described_recipe) }
  let(:node)        { runner.node }

  describe 'OpsWorks' do
    before do
      node.override['opsworks']['stack']['name'] = 'Stack'
      node.override['opsworks']['instance']['layers'] = ['pdf_autocite']
      node.override['opsworks']['instance']['hostname'] = 'host'
      node.override['opsworks']['instance']['ip'] = '127.0.0.1'
      node.override['deploy']['pdf_autocite'] = {
        'deploy_to' => '/srv/www/pdf_autocite',
        'document_root' => 'public',
        'domains' => ['domain']
      }
    end

    it 'pulls in all required recipes' do
      expect(chef_run).to include_recipe('stack-citationapi::role-phpapp')
      expect(chef_run).to include_recipe('php::module-poppler-pdf')
      expect(chef_run).to include_recipe('php::module-posix')
      expect(chef_run).to include_recipe('stack-citationapi::deploy-citationapi')
    end
  end

  describe 'Vagrant' do
    before do
      node.override['vagrant']['applications'] = {}
    end

    it 'pulls in all required recipes' do
      expect(chef_run).to include_recipe('ies-gearmand')
    end
  end
end
