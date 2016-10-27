require_relative 'spec_helper.rb'

describe 'php_ppa_package' do

  let(:cookbook_paths) do
    [
      File.expand_path("#{File.dirname(__FILE__)}/../../"),
      File.expand_path("#{File.dirname(__FILE__)}/")
    ]
  end

  let(:runner) do
    ChefSpec::SoloRunner.new(
      :cookbook_path => cookbook_paths,
      :step_into => %w(php_ppa_package)
    ) do |node|
      node.override['php']['ppa']['package_prefix'] = 'php-ppa-prefix'
      node.override['php-fpm']['prefix'] = '/prefix/dir'
      node.default['ppa_package-spec']['name'] = 'modulename'
      node.default['ppa_package-spec']['packagename'] = 'modulename'
      node.default['ppa_package-spec']['config'] = nil
    end
  end
  let(:chef_run) { runner.converge('fixtures::php-ppa_package') }
  let(:node)     { runner.node }

  describe 'without config, no separate name' do
    it 'installs the module' do
      expect(chef_run).to install_package('php-ppa-prefix-modulename')
    end

    it 'does not create config' do
      expect(chef_run).not_to render_file('/prefix/dir/etc/php/modulename-settings.ini')
    end

    it 'reloads php-fpm in the package provider' do
      package_resource = chef_run.package('php-ppa-prefix-modulename')
      expect(package_resource).to notify('service[php-fpm]').to(:reload).delayed
    end
  end

  describe 'with config, no separate name' do
    before do
      node.override['ppa_package-spec']['config'] = { 'key' => 'value' }
    end

    it 'installs the module' do
      expect(chef_run).to install_package('php-ppa-prefix-modulename')
    end

    it 'does create config' do
      expect(chef_run).to generate_php_config('modulename')
    end

    it 'reloads php-fpm in the package provider' do
      package_resource = chef_run.package('php-ppa-prefix-modulename')
      expect(package_resource).to notify('service[php-fpm]').to(:reload).delayed
    end

    it 'reloads php-fpm in the config provider' do
      package_resource = chef_run.php_config('modulename')
      expect(package_resource).to notify('service[php-fpm]').to(:reload).delayed
    end
  end

  describe 'with config, with separate name' do
    before do
      node.override['ppa_package-spec']['config'] = { 'key' => 'value' }
      node.override['ppa_package-spec']['packagename'] = 'packagename'
    end

    it 'installs the module' do
      expect(chef_run).to install_package('php-ppa-prefix-packagename')
    end

    it 'does create config' do
      expect(chef_run).to generate_php_config('modulename')
    end

    it 'reloads php-fpm in the package provider' do
      package_resource = chef_run.package('php-ppa-prefix-packagename')
      expect(package_resource).to notify('service[php-fpm]').to(:reload).delayed
    end

    it 'reloads php-fpm in the config provider' do
      package_resource = chef_run.php_config('modulename')
      expect(package_resource).to notify('service[php-fpm]').to(:reload).delayed
    end
  end

end
