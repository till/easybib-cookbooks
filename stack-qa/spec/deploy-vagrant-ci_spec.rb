require_relative 'spec_helper.rb'

describe 'stack-qa::deploy-vagrant-ci' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:user) { 'vagrant-test' }
  let(:app) { 'testapp' }

  describe 'deploy-vagrant-ci' do
    before do
      node.set['stack-qa']['vagrant-ci']['deploy']['opsworks-layer'] = 'vagrant-ci'
      node.set['stack-qa']['vagrant-ci']['deploy']['user'] = user
      node.set['stack-qa']['vagrant-ci']['deploy']['group'] = user
      node.set['stack-qa']['vagrant-ci']['deploy']['home'] = '/home/vagrant-ci'
      node.set['stack-qa']['vagrant-ci']['apps'] = [app]
      node.set['deploy'][app]['application'] = app
      node.set['opsworks']['instance']['layers'] = ['vagrant-ci']
    end

    it 'deploys the vagrant apps' do
      expect(chef_run).to deploy_easybib_deploy(app)
      expect(chef_run).to create_easybib_vagrant_user(user)
    end
  end
end
