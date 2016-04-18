require_relative 'spec_helper.rb'

describe 'php_config' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::Runner.new(
      :cookbook_path => cookbook_paths,
      :step_into => %w(php_config)
    ) do |node|
      node.override['php']['ppa']['package_prefix'] = 'php-ppa-prefix'
      node.override['php-fpm']['prefix'] = '/prefix/dir'
      node.default['config-spec']['name'] = 'modulename'
      node.default['config-spec']['config'] = { 'key' => 'value', 'modulename.secondkey' => 'value2' }
      # node['config-spec']['prefix_dir'] is fetched from ['php-fpm']['prefix'] which is set above
      node.default['config-spec']['extension_path'] = nil
      node.default['config-spec']['load_extension'] = false
      node.default['config-spec']['zend_extension'] = false
    end
  end
  let(:chef_run) { runner.converge('fixtures::php-config') }
  let(:node)     { runner.node }

  describe 'default values' do
    it 'generates the config and adds module name to keys if needed' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      expect(chef_run).to render_file(config_filename)
        .with_content(/^modulename.key="value"/)
    end

    it 'generates the config and does not add module name if already existing' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      expect(chef_run).to render_file(config_filename)
        .with_content(/^modulename.secondkey="value2"/)
    end
  end

  describe 'load_extension standard path' do
    before do
      node.set['config-spec']['extension_path'] = '/some/path.extension.so'
      node.set['config-spec']['load_extension'] = true
    end

    it 'loads the extension without zend prefix' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      fixture = 'extension=/some/path.extension.so'

      expect(chef_run).to render_file(config_filename)
        .with_content(start_with(fixture))
    end

    it 'generates the config' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      fixture = 'modulename.key="value"'

      expect(chef_run).to render_file(config_filename)
        .with_content(fixture)
    end
  end

  describe 'load_extension zend extension' do
    before do
      node.set['config-spec']['extension_path'] = '/some/path.extension.so'
      node.set['config-spec']['load_extension'] = true
      node.set['config-spec']['zend_extension'] = true
    end

    it 'loads the extension with zend prefix' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      fixture = 'zend_extension=/some/path.extension.so'

      expect(chef_run).to render_file(config_filename)
        .with_content(start_with(fixture))
    end

    it 'generates the config' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      fixture = 'modulename.key="value"'

      expect(chef_run).to render_file(config_filename)
        .with_content(fixture)
    end
  end

  describe 'extension set but load false' do
    before do
      node.set['config-spec']['extension_path'] = '/some/path.extension.so'
      node.set['config-spec']['load_extension'] = false
      node.set['config-spec']['zend_extension'] = true
    end

    it 'does not load the extension' do
      config_filename = '/prefix/dir/etc/php/modulename-settings.ini'

      fixture = 'extension=/some/path.extension.so'

      expect(chef_run).not_to render_file(config_filename)
        .with_content(fixture)
    end
  end

  describe 'another path' do
    before do
      node.set['config-spec']['config_dir'] = 'etc/php/5.6/conf.d'
      node.set['config-spec']['ini_suffix'] = ''
    end

    it 'creates a .ini file' do
      expect(chef_run).to render_file('/prefix/dir/etc/php/5.6/conf.d/modulename.ini')
    end
  end

  describe 'load priority' do
    before do
      node.set['config-spec']['config_dir'] = 'etc/php/5.6/conf.d'
      node.set['config-spec']['load_priority'] = 10
    end

    it 'creates a .ini file with load priority' do
      expect(chef_run).to render_file('/prefix/dir/etc/php/5.6/conf.d/10-modulename-settings.ini')
    end
  end
end
