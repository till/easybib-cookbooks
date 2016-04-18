require_relative 'spec_helper.rb'
require_relative 'shared/nginx-config.rb'

describe 'stack-cmbm::deploy-nginxapp' do

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
  end
end
