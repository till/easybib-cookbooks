require 'chefspec'

describe 'composer::configure' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :log_level => :error
    )
  end

  let(:chef_run) { runner.converge('composer::configure') }
  let(:node)     { runner.node }
  let(:oauth)    { '123-super-secret-key' }

  describe 'configure/no user' do
    it 'returns early' do
      expect(chef_run).not_to create_directory('foo')
      expect(chef_run).not_to render_file('foo')
    end
  end

  describe 'configure/empty OAuth2 token' do
    before do
      node.set['composer']['environment'] = {
        'user' => 'root',
        'group' => 'root'
      }

      Dir.stub(:home) { '/root' }
    end

    it 'does not setup a config.json' do
      expect(chef_run).not_to create_directory('/root/.composer/')
      expect(chef_run).not_to render_file('/root/.composer/config.json')
    end
  end

  describe 'configure' do
    before do
      node.set['composer']['environment'] = {
        'user' => 'www-data',
        'group' => 'www-data'
      }

      node.set['composer']['oauth_key'] = oauth

      Dir.stub(:home) { '/var/www' }
    end

    it 'creates a config.json' do
      expect(chef_run).to render_file('/var/www/.composer/config.json')
        .with_content(
          include("github.com\": \"#{oauth}\"")
        )
    end
  end
end
