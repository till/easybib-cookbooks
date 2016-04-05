require 'chefspec'

describe 'stack-scholar::deploy' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }
  let(:deploy_data) { { 'deploy_to' => '/bla/dir', 'document_root' => 'www', 'domains' => ['foo.tld'] } }

  describe 'scholar_admin deployment in correct layer' do
    before do
      node.set['opsworks']['instance']['layers'] = ['nginxphpapp']
      node.set['deploy']['scholar_admin'] = deploy_data
    end

    it 'includes the service definition recipes' do
      expect(chef_run).to include_recipe('php-fpm::service')
      expect(chef_run).to include_recipe('nginx-app::service')
    end

    it 'deploys the application' do
      expect(chef_run).to deploy_easybib_deploy('scholar_admin')
        .with(
          :deploy_data => deploy_data,
          :app => 'scholar_admin'
        )
    end

    it 'creates the nginx config with the correct template' do
      expect(chef_run).to setup_easybib_nginx('scholar_admin')
        .with(
          :config_template => 'silex.conf.erb',
          :doc_root => 'www',
          :listen_opts => nil
        )
    end
  end

  describe 'scholar_admin deployment in wrong layer' do
    before do
      node.set['opsworks']['instance']['layers'] = ['wronglayer']
      node.set['deploy']['scholar_admin'] = deploy_data
    end

    it 'does not deploy the application' do
      expect(chef_run).not_to deploy_easybib_deploy('scholar_admin')
    end

    it 'does not create the nginx config ' do
      expect(chef_run).not_to setup_easybib_nginx('scholar_admin')
    end
  end

  # scholar main app
  describe 'scholar deployment in nginxlayer' do
    before do
      node.set['opsworks']['instance']['layers'] = ['nginxphpapp']
      node.set['deploy']['scholar'] = deploy_data
    end

    it 'includes the service definition recipes' do
      expect(chef_run).to include_recipe('php-fpm::service')
      expect(chef_run).to include_recipe('nginx-app::service')
    end

    it 'deploys the application' do
      expect(chef_run).to deploy_easybib_deploy('scholar')
        .with(
          :deploy_data => deploy_data,
          :app => 'scholar'
        )
    end

    it 'creates the nginx config with the correct template' do
      expect(chef_run).to setup_easybib_nginx('scholar')
        .with(
          :config_template => 'scholar.conf.erb',
          :doc_root => 'www',
          :listen_opts => 'default_server'
        )
    end
  end

  describe 'scholar deployment in supervisor layer' do
    before do
      node.set['opsworks']['instance']['layers'] = ['supervisor_role']
      node.set['easybib_deploy']['supervisor_role'] = 'supervisor_role'
      node.set['deploy']['scholar'] = deploy_data
    end

    # not testing for values or nginx here, since this is redundant to test above
    it 'deploys the application' do
      expect(chef_run).to deploy_easybib_deploy('scholar')
    end
  end

  describe 'scholar deployment in wrong layer' do
    before do
      node.set['opsworks']['instance']['layers'] = ['wronglayer']
      node.set['deploy']['scholar'] = deploy_data
    end

    it 'does not deploy the application' do
      expect(chef_run).not_to deploy_easybib_deploy('scholar')
    end

    it 'does not create the nginx config ' do
      expect(chef_run).not_to setup_easybib_nginx('scholar')
    end
  end
end
