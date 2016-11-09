require_relative 'spec_helper.rb'

describe 'php::module-sybase' do

  let(:runner)    { ChefSpec::Runner.new }
  let(:chef_run)  { runner.converge(described_recipe) }
  let(:node)      { runner.node }

  let(:freetds_config) { '/etc/freetds/freetds.conf' }

  describe 'php5-easybib' do
    it 'does not install freetds and php5-easybib' do
      expect(chef_run).not_to install_package('freetds-bin')
      expect(chef_run).not_to install_package('php5-sybase')
    end

    it 'does not render the freetds config' do
      expect(chef_run).not_to render_file(freetds_config)
    end
  end

  describe 'ondrej ppa' do
    before do
      node.override['freetds'] = {
        'server_name' => 'my_mssql_server',
        'host' => 'some.host.lan'
      }

      node.override['php']['ppa'] = {
        'name' => 'ondrejphp',
        'uri' => 'ppa:ondrej/php',
        'package_prefix' => 'php7.0'
      }
    end
    it 'installs freetds and phpXXX-sybase' do
      expect(chef_run).to install_package('freetds-bin')
      expect(chef_run).to install_package('php7.0-sybase')
    end

    it 'configures freetds' do
      expect(chef_run).to create_template(freetds_config)
    end

    it 'creates the config with the correct content' do
      config_file = "[my_mssql_server]\n"
      config_file << "  host = some.host.lan\n"
      config_file << "  port = 1433\n"
      config_file << "  tds version = 8.0\n"
      config_file << '  client charset = UTF-8'

      expect(chef_run).to render_file(freetds_config)
        .with_content(config_file)
    end
  end
end
