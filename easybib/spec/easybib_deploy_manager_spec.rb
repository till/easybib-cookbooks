require 'chefspec'

describe 'easybib_deploy_manager' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :platform => 'ubuntu',
      :version => '16.04',
      :cookbook_path => cookbook_paths,
      :log_level => :error,
      :step_into => %w(
        easybib_deploy_manager
        easybib_deploy
        easybib_nginx)
    )
  end

  let(:node) { runner.node }
  let(:fixture) { 'fixtures::easybib_deploy_manager_broken_apps' }

  context 'no deployments' do
    before do
      node.override['deploy'] = {}
    end

    it 'logs when no applications are configured' do
      @chef_run = runner.converge(fixture)
      pending 'need to explore how to assert on Chef::Log in a LWRP'
      expect(Chef::Log).to receive(:info).with('easybib_deploy_manager: No apps configured')
      expect(@chef_run).to deploy_easybib_deploy_manager('fixtures')
    end

    context 'apps but no deploy' do
      before do
        node.override['fixtures']['applications'] = {
          :app_number_one => {},
          :app_number_two => {}
        }
      end

      it 'does not call easybib_deploy' do
        @chef_run = runner.converge(fixture)

        %w(app_number_one app_number_two).each do |application|
          expect(@chef_run).not_to deploy_easybib_deploy(application)
          expect(@chef_run).not_to setup_easybib_nginx(application)
        end
      end
    end
  end

  context 'deployments' do
    before do
      node.override['deploy'] = {
        :app_number_one => {
          :deploy_to => '/var/www/app1',
          :document_root => 'www',
          :domains => %w( example.org )
        },
        :app_number_two => {
          :deploy_to => '/var/www/app2',
          :document_root => 'htdocs',
          :domains => %w( app2.example.org example2.org )
        }
      }

      node.override['fixtures']['applications'] = {
        :app_number_one => {
          :layer => 'app-server',
          :nginx => 'silex.erb.conf'
        },
        :app_number_two => {
          :layer => 'app-server',
          :nginx => 'silex.erb.conf'
        }
      }

      node.override['opsworks'] = {
        :instance => {
          :layers => ['app-server']
        },
        :stack => {
          :name => 'chefspec'
        }
      }

      @chef_run = runner.converge('fixtures::easybib_deploy_manager')
    end

    it 'deploys an app' do
      expect(@chef_run).to deploy_easybib_deploy_manager('fixtures')

      deploy_manager = @chef_run.easybib_deploy_manager('fixtures')
      expect(deploy_manager).to notify('execute[foo]').to(:run).delayed

      %w( app_number_one app_number_two).each do |application|
        expect(@chef_run).to deploy_easybib_deploy(application)
        expect(@chef_run).to setup_easybib_nginx(application)
          .with(
            :cookbook => 'nginx-app'
          )
      end
    end

    context 'deploys an app with extended cookbook/nginx conf' do
      before do
        node.override['fixtures']['applications'] = {
          :app_number_one => {
            :layer => 'app-server',
            :nginx => {
              :cookbook => 'stack-academy',
              :conf => 'infolit.conf.erb'
            }
          }
        }

        @chef_run = runner.converge('fixtures::easybib_deploy_manager')
      end

      it 'runs easybib_nginx' do
        expect(@chef_run).to setup_easybib_nginx('app_number_one')
          .with(
            :cookbook => 'stack-academy',
            :config_template => 'infolit.conf.erb'
          )
      end
    end
  end
end
