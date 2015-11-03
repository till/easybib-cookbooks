require 'chefspec'

describe 'apache-couchdb::configure' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :error
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  describe 'files' do
    it 'includes apache-couchdb::monitoring' do
      expect(chef_run).to include_recipe('apache-couchdb::monitoring')
    end
  end

  describe 'configuration' do
    before do
      node.set['apache-couchdb']['config']['admins'] = {
        'foo' => 'bar',
        'foobar' => 'test123'
      }
    end

    it 'sets up admin accounts in local.ini' do
      conf = "[admins]\n"
      conf << "foo = bar\n"
      conf << 'foobar = test123'

      expect(chef_run).to render_file('/etc/couchdb/local.d/local.ini')
        .with_content(conf)
    end
  end
end
