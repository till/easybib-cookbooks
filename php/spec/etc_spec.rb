require_relative 'spec_helper.rb'

describe 'php::module-apc' do
  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => %w(php_ppa_package php_config)
    )
  end

  let(:node) { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:ini_file) { '/etc/php/7.0/mods-available/apc-settings.ini' }

  # The following should serve as an example of what is required to correctly setup
  # PHP7.0 etc. or so from ondrej's launchpad PPA
  before do
    node.override['php']['extensions']['config_dir'] = 'etc/php/7.0/mods-available'
    node.override['php']['ppa'] = {
      'name' => 'ondrejphp',
      'uri' => 'ppa:ondrej/php',
      'package_prefix' => 'php7.0'
    }
    node.override['php-apc']['package_prefix'] = 'php'
    node.override['php-fpm'] = {
      'prefix' => '',
      'exec_prefix' => '/usr',
      'fpm_config' => 'etc/php/7.0/fpm/php.ini',
      'cli_config' => 'etc/php/7.0/cli/php.ini',
      'pool_dir' => 'etc/php/7.0/fpm/pool.d',
      'socketdir' => '/var/run/php',
      'pid' => '/var/run/php/php7.0-fpm.pid',
      'packages' => 'php7.0-fpm,php7.0-cli,php7.0-pdo-mysql,php7.0-curl'
    }
  end

  it 'installs php-apcu (PHP 7.0)' do
    expect(chef_run).to install_package('php-apcu')
  end

  it 'installs apc-settings.ini into /etc/php/7.0/mods-available' do
    expect(chef_run).to render_file(ini_file)
  end

  it 'enables the module for the cli' do
    expect(chef_run).to create_link('enable_module_cli_apc')
      .with(
        :target_file => '/etc/php/7.0/cli/conf.d/apc-settings.ini',
        :to => ini_file
      )
  end

  it 'enables the module for the fpm' do
    expect(chef_run).to create_link('enable_module_fpm_apc')
      .with(
        :target_file => '/etc/php/7.0/fpm/conf.d/apc-settings.ini',
        :to => ini_file
      )
  end
end
