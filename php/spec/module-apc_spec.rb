require_relative 'spec_helper.rb'

describe 'php::module-apc' do

  let(:chef_run) do
    ChefSpec::Runner.new(:step_into => %w(php_ppa_package php_config)) do |node|
      # fake opsworks
      node.default['opsworks']['stack']['name'] = 'chef-spec-run'
      node.default['opsworks']['instance']['layers'] = []
      node.default['php']['ppa']['package_prefix'] = 'php5-easybib'
      node.default['php-fpm']['prefix'] = '/opt/easybib'
    end.converge(described_recipe)
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('php::dependencies-ppa')
  end

  it 'adds php-fpm service definition' do
    expect(chef_run).to include_recipe('php-fpm::service')
  end

  it 'installs the apc module' do
    expect(chef_run).to install_package('php5-easybib-apcu')
  end

  it 'creates apc-settings.ini' do
    expect(chef_run).to render_file('/opt/easybib/etc/php/apc-settings.ini')
  end

  # while we could test this using the php_ppa_package matcher, I opted to step into
  # them to test the actual result - this is because of the unique is_aws config merge
  # in the recipe, which I want to test if it ends up in the actual config rightfully.
  # If you want to see a test sample how this usually should be done, see module-mysqli_spec.rb
  # since the actual config generation part is already tested in provider-config_spec.rb
  it 'it contains production settings' do
    conf = "apc.stat=\"0\"\n"
    conf << "apc.slam_defense=\"1\"\n"
    conf << "apc.max_file_size=\"2M\"\n"
    conf << "apc.ttl=\"0\"\n"
    conf << "apc.mmap_file_mask=\"/dev/zero\"\n"
    conf << "apc.shm_size=\"70M\"\n"

    expect(chef_run).to render_file('/opt/easybib/etc/php/apc-settings.ini').with_content(conf)
  end

end
