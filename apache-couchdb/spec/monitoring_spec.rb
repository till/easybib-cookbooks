require 'chefspec'

describe 'apache-couchdb::configure' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :error
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:couchdb_check) { '/usr/local/bin/check_couchdb' }

  describe 'monitoring' do
    it 'includes apache-couchdb::monitoring' do
      expect(chef_run).to include_recipe('apache-couchdb::monitoring')
    end

    it 'does not create check_couchdb' do
      expect(chef_run).not_to create_template(couchdb_check)
    end
  end

  describe 'setup monitoring' do
    before do
      node.set['apache-couchdb']['config']['admins'] = {
        'monitoring' => 'test123'
      }
    end

    it 'it creates check_couchdb' do
      expect(chef_run).to create_template(couchdb_check)
    end

    it 'includes the monitoring user with "test123"' do
      expect(chef_run).to render_file(couchdb_check)
        .with_content(include('monitoring:test123'))
    end
  end
end
