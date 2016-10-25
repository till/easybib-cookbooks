require_relative 'spec_helper.rb'

describe 'php::module-poppler-pdf' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['poppler']['package_uri']        = 'http://foo.bar/package'
      node.set['poppler']['package_distro']     = 'trusty'
      node.set['poppler']['package_components'] = ['main']
      node.set['poppler']['package_key_uri']    = 'keyfile.gpg'
    end.converge(described_recipe)
  end

  let(:ext) { 'poppler.so' }

  it 'adds poppler mirror' do
    expect(chef_run).to include_recipe('php::dependencies-ppa')
  end
  it 'adds poppler mirror' do
    expect(chef_run).to add_apt_repository('poppler').with(
      :uri => 'http://foo.bar/package',
      :key => 'keyfile.gpg',
      :distribution => 'trusty',
      :components => ['main']
    )
  end

  it 'installs poppler libraries ' do
    expect(chef_run).to install_package 'poppler'
    expect(chef_run).to install_package 'poppler-glib'
  end

  it 'installs the extension' do
    expect(chef_run).to install_package('php-poppler-pdf')
  end

  it 'configures the extension' do
    expect(chef_run).to generate_php_config(File.basename(ext, '.so'))
  end

end
