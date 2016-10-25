require_relative 'spec_helper.rb'

describe 'php::module-soap' do
  let(:runner) do
    ChefSpec::Runner.new(
      :step_into => %w(php_config)
    )
  end

  let(:node) { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }

  before do
    node.set['php']['ppa']['package_prefix'] = 'php5.6'
    node.set['php-fpm']['tmpdir']            = '/tmp/chefspec/php'
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('php::dependencies-ppa')
  end

  it 'adds php-fpm service definition' do
    expect(chef_run).to include_recipe('php-fpm::service')
  end

  it 'installs the soap extension' do
    expect(chef_run).to install_php_ppa_package('soap')
  end

  it 'creates soap-settings.ini' do
    expect(chef_run).to generate_php_config('soap')
      .with(
        :config => {
          'wsdl_cache_enabled' => 1,
          'wsdl_cache_ttl' => 86_400,
          'wsdl_cache_limit' => 5,
          'wsdl_cache_dir' => '/tmp/chefspec/php'
        }
      )
    expect(chef_run).to render_file('/opt/easybib/etc/php/soap-settings.ini')
  end

  describe 'with load_priority set' do
    before do
      node.set['php-soap']['load_priority'] = 99
    end
    it 'does not create soap-settings.ini without load_priority' do
      expect(chef_run).to_not render_file('/opt/easybib/etc/php/soap-settings.ini')
    end
    it 'creates soap-settings.ini with load_priority' do
      expect(chef_run).to render_file('/opt/easybib/etc/php/99-soap-settings.ini')
    end
  end

end
