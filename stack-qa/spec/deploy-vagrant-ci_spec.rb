require 'chefspec'

describe 'stack-qa::deploy-vagrant-ci' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :platform => 'Ubuntu',
      :version => '12.04'
    )
  end

  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:user) { 'vagrant-test' }
  let(:app) { 'testapp' }

  describe 'deploy-vagrant-ci' do
    before do
      node.set['stack-qa']['vagrant-ci'] = {
        'apps' => [app],
        'deploy_user' => user
      }

      # general stack info
      node.set['applications'] = [
        {
          'name' => app,
          'slug_name' => app,
          'application_type' => 'other'
        }
      ]

      # when an app is being deployed
      node.set['deploy'] = {
        app => {
          'application' => app,
          'application_type' => 'other'
        }
      }

      # current instance
      node.set['opsworks'] = {
        'instance' => {
          'layers' => [
            'vagrant-ci'
          ]
        }
      }

      Dir.stub(:home) { "/home/#{user}" }
    end

    it "deploys 'testapp' on 'vagrant-ci'" do
      # expect(Chef::Log).to receive(:debug).with("Deployed: #{app}")
    end

    it 'continues to setup vagrant, .ssh/config and .bash_profile' do
      expect(chef_run).to include_recipe('easybib_vagrant')
      expect(chef_run).to render_file("/home/#{user}/.ssh/config")
      expect(chef_run).to include_recipe('bash::profile')
    end
  end
end
