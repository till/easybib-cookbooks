require_relative 'spec_helper.rb'

describe 'stack-easybib::role-gearmanw' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:stack) { 'Stack Name' }

  describe 'AWS' do
    before do
      node.override['deploy'] = {}
      node.override['easybib']['cluster_name'] = stack
      node.override['opsworks']['stack']['name'] = stack
      node.override['opsworks']['instance'] = {
        'layers' => ['nginxphpapp'],
        'hostname' => 'hostname',
        'ip' => '127.0.0.1'
      }
    end

    it 'sets up the cronjob' do
      expect(chef_run).to create_cron_d('pdf_autocite_cleanup')
        .with(
          :command => "find /tmp/ -daystart -maxdepth 1 -mmin +240 -type f -name 'pdf-autocite*' -execdir rm -- {} \\;"
        )
    end
  end
end
