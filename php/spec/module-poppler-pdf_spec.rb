require_relative 'spec_helper.rb'

describe 'php::module-poppler-pdf' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['poppler']['package_uri'] = 'http://foo.bar/package'
      node.set['poppler']['package_distro'] = 'trusty'
      node.set['poppler']['package_components'] = ['main']
      node.set['poppler']['package_key_uri'] = 'http://foo.bar/key'
    end.converge(described_recipe)
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to add_apt_repository('poppler').with(
      :uri => 'http://foo.bar/package',
      :key => 'http://foo.bar/key',
      :distribution => 'trusty',
      :components => ['main']
    )
  end

  it 'installs libraries and the extension' do
    expect(chef_run).to install_package 'poppler'
    expect(chef_run).to install_package 'poppler-glib'
    expect(chef_run).to install_package 'php-poppler-pdf'
  end
end
