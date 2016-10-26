require_relative 'spec_helper.rb'
require_relative 'shared/nginx-config.rb'
require 'set'

describe 'stack-citationapi::deploy-citationapi' do

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'citation data api nginx config' do
    let(:app_config_shortname) { 'citation_apis' }

    before do
      node.override['deploy']['citation_apis'] = {
        'deploy_to' => '/srv/www/citation_apis',
        'document_root' => 'public'
      }
      node.override['opsworks']['instance']['layers'] = ['citation-apis']
    end

    it_behaves_like 'silex nginx template'
  end

  describe 'citation formatting api nginx config' do
    let(:app_config_shortname) { 'easybib_api' }

    before do
      node.override['deploy']['easybib_api'] = {
        'deploy_to' => '/srv/www/easybib_api',
        'document_root' => 'public'
      }
      node.override['opsworks']['instance']['layers'] = ['bibapi']
    end

    it_behaves_like 'silex nginx template'
  end

  describe 'sitescraper nginx config' do
    let(:app_config_shortname) { 'sitescraper' }

    before do
      node.override['deploy']['sitescraper'] = {
        'deploy_to' => '/srv/www/sitescraper',
        'document_root' => 'public'
      }
      node.override['opsworks']['instance']['layers'] = ['sitescraper']
    end

    it_behaves_like 'silex nginx template'
  end

  describe 'pdf_autocite' do
    let(:app_config_shortname) { 'pdf_autocite' }
    let(:deploy_to) { '/srv/www/pdf_autocite' }

    before do
      node.override['deploy']['pdf_autocite'] = {
        'deploy_to' => deploy_to,
        'document_root' => 'web',
        'domains' => ['pdf.example.org']
      }
      node.override['opsworks']['instance']['layers'] = ['pdf_autocite']
    end

    it 'calls all necessary LWRP' do
      expect(chef_run).to deploy_easybib_deploy(app_config_shortname)
      expect(chef_run).to setup_easybib_nginx(app_config_shortname)
      expect(chef_run).to create_easybib_envconfig(app_config_shortname)
      expect(chef_run).to create_easybib_supervisor("#{app_config_shortname}_supervisor")
      expect(chef_run).to create_easybib_gearmanw("#{deploy_to}/current/")
    end
  end
end
