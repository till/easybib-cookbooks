require_relative 'spec_helper'

describe 'easybib_deploy_manager' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :log_level => :debug,
      :step_into => ['easybib_deploy_manager']
    )
  end

  let(:node) { runner.node }
  let(:fixture) { 'fixtures::easybib_deploy_manager_broken_apps' }

  context 'no deployments' do
    before do
      node.set['deploy'] = {}
    end

    it 'logs when no applications are configured' do
      # @chef_run = runner.converge(fixture)
      # expect(Chef::Log).to receive(:info).with('easybib_deploy_manager: No apps configured')
      # expect(@chef_run).to deploy_easybib_deploy_manager('fixtures')
      pending 'need to explore how to assert on Chef::Log in a LWRP'
    end

    context 'apps but no deploy' do
      before do
        node.set['fixtures']['applications'] = {
          :app_number_one => {},
          :app_number_two => {}
        }
      end

      it 'it logs accordingly' do
        # expect(Chef::Log).to receive(:info).with('easybib_deploy_manager: No deployments')
        # @chef_run = runner.converge(fixture)
        # expect(@chef_run).to deploy_easybib_deploy_manager('fixtures')
        pending 'need to explore how to assert on Chef::Log in a LWRP'
      end
    end
  end
end
