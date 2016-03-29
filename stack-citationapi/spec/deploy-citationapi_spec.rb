require_relative 'spec_helper.rb'
require_relative 'shared/nginx-config.rb'
require 'set'

describe 'stack-citationapi::deploy-citationapi' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'citation data api nginx config' do
    let(:app_config_shortname) { 'citation_apis' }

    before do
      node.set['deploy']['citation_apis'] = {
        'deploy_to' => '/srv/www/citation_apis',
        'document_root' => 'public'
      }
      node.set['opsworks']['instance']['layers'] = ['citation-apis']
    end

    it_behaves_like 'silex nginx template'
  end

  describe 'citation formatting api nginx config' do
    let(:app_config_shortname) { 'easybib_api' }

    before do
      node.set['deploy']['easybib_api'] = {
        'deploy_to' => '/srv/www/easybib_api',
        'document_root' => 'public'
      }
      node.set['opsworks']['instance']['layers'] = ['bibapi']
    end

    it_behaves_like 'silex nginx template'
  end

  describe 'sitescraper nginx config' do
    let(:app_config_shortname) { 'sitescraper' }

    before do
      node.set['deploy']['sitescraper'] = {
        'deploy_to' => '/srv/www/sitescraper',
        'document_root' => 'public'
      }
      node.set['opsworks']['instance']['layers'] = ['sitescraper']
    end

    it_behaves_like 'silex nginx template'
  end
end
