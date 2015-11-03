require 'chefspec'

describe 'apache-couchdb::configure' do

  let(:runner) do
    ChefSpec::Runner.new(
      :log_level => :error
    )
  end
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  let(:local_dir) { '/etc/couchdb/local.d' }

  describe 'files' do
    it 'includes apache-couchdb::monitoring' do
      expect(chef_run).to include_recipe('apache-couchdb::monitoring')
    end
  end

  describe 'configuration' do
    before do
      # the following assumes it's the first time the setup is ran
      allow(File).to receive(:exist?).and_call_original

      node.set['apache-couchdb']['config']['admins'] = {
        'foo' => 'bar',
        'foobar' => 'test123'
      }
      node.set['apache-couchdb']['config']['till'] = 'foo'
    end

    it 'sets up admin accounts in local.ini' do
      conf = "[admins]\n"
      conf << "foo = bar\n"
      conf << 'foobar = test123'

      expect(chef_run).to render_file("#{local_dir}/local.ini")
        .with_content(conf)
    end

    it 'sets up local.ini, till.ini and NOT admins.ini' do
      expect(chef_run).to render_file("#{local_dir}/local.ini")
      expect(chef_run).to render_file("#{local_dir}/till.ini")
      expect(chef_run).not_to render_file("#{local_dir}/admins.ini")
    end
  end

  describe 'repeat deployment' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with("#{local_dir}/local.ini")
        .and_return(true)
    end

    it 'does not overwrite an existing local.ini' do
      expect(chef_run).not_to render_file("#{local_dir}/local.ini")
    end
  end
end
