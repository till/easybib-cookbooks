require_relative 'spec_helper.rb'
require_relative 'shared/nginx-config.rb'

describe 'stack-cmbm::deploy-vagrant' do

  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => ['easybib_nginx']
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'cmbm nginx config' do
    let(:app_config_shortname) { 'cmbm' }

    before do
      node.set[:vagrant][:applications] = {
        :cmbm => {
          :app_root_location => '/vagrant_cmbm',
          :doc_root_location => '/vagrant_cmbm/public',
          :default_router => '',
          :domain_name => 'cmbm.bib'
        }
      }
    end

    it_behaves_like 'puma nginx template'

    it 'includes all required recipes' do
      expect(chef_run).to include_recipe('nginx-app::server')
      expect(chef_run).to include_recipe('supervisor')
    end

    it 'installs bundler' do
      expect(chef_run).to run_execute('install bundler')
    end

    it 'installs all gem dependencies' do
      expect(chef_run).to run_execute('install gem dependencies')
    end

    it 'sets up the app' do
      expect(chef_run).to run_execute('setup app')
    end
  end
end
