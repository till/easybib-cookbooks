require_relative 'spec_helper.rb'
require_relative '../libraries/config'

describe 'php::module-aws_elasticache_cluster_client' do

  let(:runner) { ChefSpec::Runner.new(:step_into => %w(php_pecl php_config)) }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  let(:ext) { 'amazon-elasticache-cluster-client.so' }

  let(:ext_dir) { '/usr/lib/php/20151012' }

  let(:my_config) { double(Php::Config) }

  before do
    node.override['php']['extensions']['config_dir'] = 'etc/php/7.0/mods-available'
    node.override['php']['ppa'] = {
      'name' => 'ondrejphp',
      'uri' => 'ppa:ondrej/php',
      'package_prefix' => 'php7.0'
    }
    node.override['php-fpm'] = {
      'prefix' => '',
      'exec_prefix' => '/usr',
      'fpm_config' => 'etc/php/7.0/fpm/php.ini',
      'cli_config' => 'etc/php/7.0/cli/php.ini',
      'pool_dir' => 'etc/php/7.0/fpm/pool.d',
      'socketdir' => '/var/run/php',
      'pid' => '/var/run/php/php7.0-fpm.pid',
      'packages' => 'php7.0-fpm,php7.0-cli'
    }

    Php::Config.stub(:new).and_return(my_config)
    my_config.stub(:get_extension_dir).with('/usr').and_return(ext_dir)
    my_config.stub(:get_directives).and_return({})
  end

  it 'uses php_pecl to copy the file' do
    expect(chef_run).to copy_php_pecl(ext)
  end

  it 'actually copies the file in place' do
    expect(chef_run).to create_cookbook_file("#{ext_dir}/#{ext}")
  end

  it 'configures the extension' do
    expect(chef_run).to generate_php_config(File.basename(ext, '.so'))
  end

  it 'renders the file' do
    ini = '/etc/php/7.0/mods-available/10-amazon-elasticache-cluster-client.ini'
    expect(chef_run).to create_template(ini)
    expect(chef_run).to render_file(ini)
      .with_content('extension=amazon-elasticache-cluster-client.so')
  end

  it 'creates links the ini file' do
    %w(cli fpm).each do |sapi|
      expect(chef_run).to create_link("enable_module_#{sapi}_amazon-elasticache-cluster-client")
    end
  end
end
