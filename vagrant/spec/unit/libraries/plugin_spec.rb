require_relative '../../../libraries/plugin'

RSpec.describe Vagrant::Plugin do
  let(:windows_user) { { username: 'my_user', password: 'my_password' } }
  let(:unix_user) { { username: 'my_user' } }

  let(:windows_plugin_list) { "simple-plugin (0.1.0, system)\r\ntwo-digit-minor (1.12.34)\r\nvagrant-foobar (2.3.4)" }
  let(:unix_plugin_list) { windows_plugin_list.gsub(/\r\n/, "\n") }

  def plugin_cli_with_vpl_mocked(name, is_windows, options = {})
    cli = Vagrant::Plugin.new(name, is_windows, options)
    list = cli.windows? ? windows_plugin_list : unix_plugin_list
    allow(cli).to receive(:vagrant_plugin_list).and_return(list)
    cli
  end

  def windows_cli_with_vpl_mocked(name, options = {})
    plugin_cli_with_vpl_mocked(name, true, options)
  end

  def unix_cli_with_vpl_mocked(name, options = {})
    plugin_cli_with_vpl_mocked(name, false, options)
  end

  describe '#version' do
    context 'On Windows' do
      it 'given a non-installed plugin, returns nil' do
        version = windows_cli_with_vpl_mocked('non-existent').installed_version
        expect(version).to be_nil
      end

      it 'given an installed plugin name, returns the version' do
        version = windows_cli_with_vpl_mocked('simple-plugin').installed_version
        expect(version).to eq '0.1.0'
      end

      it 'given a cli configured with a plugin that has a 2-digit minor version, returns the version' do
        version = windows_cli_with_vpl_mocked('two-digit-minor').installed_version
        expect(version).to eq '1.12.34'
      end

      it 'given a cli configured with a user to impersonate, returns the correct version' do
        version = windows_cli_with_vpl_mocked('vagrant-foobar', windows_user).installed_version
        expect(version).to eq '2.3.4'
      end
    end

    context 'On Unix' do
      it 'given a cli configured with a non-installed plugin, returns nil' do
        version = unix_cli_with_vpl_mocked('non-existent').installed_version
        expect(version).to be_nil
      end

      it 'given a cli configured with a name, returns the version' do
        version = unix_cli_with_vpl_mocked('simple-plugin').installed_version
        expect(version).to eq '0.1.0'
      end
    end
  end

  describe '#install' do
    it 'given no version or source, executes vagrant plugin install' do
      cli = Vagrant::Plugin.new('simple-plugin', true)
      expect(cli).to receive(:execute_cli).with('vagrant plugin install simple-plugin')
      cli.install
    end

    it 'given a version, executes vagrant plugin install targetting the version' do
      cli = Vagrant::Plugin.new('version-plugin', false)
      expect(cli).to receive(:execute_cli).with('vagrant plugin install version-plugin --plugin-version 0.1.0')
      cli.install('0.1.0')
    end

    it 'given a source, executes vagrant plugin install from the source' do
      cli = Vagrant::Plugin.new('source-plugin', true)
      expect(cli).to receive(:execute_cli).with('vagrant plugin install source-plugin --plugin-source https://in-house.server.com/')
      cli.install(nil, ['https://in-house.server.com/'])
    end

    it 'given two sources, executes vagrant plugin install with both sources' do
      cli = Vagrant::Plugin.new('sources-plugin', false)
      expect(cli).to receive(:execute_cli).with('vagrant plugin install sources-plugin --plugin-source https://in-house.server.com/ --plugin-source https://alternate.source.com')
      cli.install(nil, ['https://in-house.server.com/', 'https://alternate.source.com'])
    end

    it 'given both a version and a source, executes vagrant plugin install with both constraints' do
      cli = Vagrant::Plugin.new('version-plugin', true)
      expect(cli).to receive(:execute_cli).with('vagrant plugin install version-plugin --plugin-version 0.1.0 --plugin-source https://in-house.server.com/')
      cli.install('0.1.0', ['https://in-house.server.com/'])
    end
  end

  describe '#uninstall' do
    it 'executes vagrant plugin uninstall' do
      cli = Vagrant::Plugin.new('byebye-plugin', true)
      expect(cli).to receive(:execute_cli).with('vagrant plugin uninstall byebye-plugin')
      cli.uninstall
    end
  end
end
