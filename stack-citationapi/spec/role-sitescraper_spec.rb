require_relative 'spec_helper.rb'

describe 'stack-citationapi::role-sitescraper' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'OpsWorks' do
    before do
      node.set['opsworks']['stack']['name']        = 'Stack'
      node.set['opsworks']['instance']['layers']   = ['sitescraper']
      node.set['opsworks']['instance']['hostname'] = 'host'
      node.set['opsworks']['instance']['ip']       = '127.0.0.1'
      node.set['deploy']['sitescraper']            = {
        'deploy_to' => '/srv/www/sitescraper',
        'document_root' => 'public'
      }
    end

    it 'installs a php server' do
      expect(chef_run).to include_recipe('stack-citationapi::role-phpapp')
    end

    it 'starts the app deployment' do
      expect(chef_run).to include_recipe('stack-citationapi::deploy-citationapi')
    end

    it 'creates the nginx config with the correct template' do
      expect(chef_run).to setup_easybib_nginx('sitescraper')
        .with(
          :config_template => 'default-web-nginx.conf.erb'
        )
    end
  end

  describe 'vagrant' do
    before do
      node.set['vagrant']['applications'] = {
        :sitescraper => {
          :default_router => 'index_tralala.php',
          :deploy_dir => '/vagrant_autocite',
          :doc_root_location => '/vagrant_autocite/www',
          :domain_name => ['example.org']
        }
      }
    end

    it 'uses deploy-vagrant' do
      expect(chef_run).to include_recipe('stack-citationapi::deploy-vagrant')
    end

    it 'calls the LWRPs' do
      expect(chef_run).to setup_easybib_nginx('sitescraper')
      expect(chef_run).to create_easybib_envconfig('sitescraper')
      expect(chef_run).to create_easybib_supervisor('sitescraper_supervisor')
      expect(chef_run).to create_easybib_gearmanw('/vagrant_autocite/')
    end
  end

end
