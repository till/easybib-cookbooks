require 'chefspec'

describe 'php-xdebug::default' do

  let (:chef_run) do
    ChefSpec::Runner.new do |node|
      node.default['apt'] = {}
      node.default.apt['easybib'] = {}
      node.default.apt.easybib['ppa'] = 'ppa:easybib/php55'
    end.converge(described_recipe)
  end

  it 'creates xdebug-settings.ini' do
    expect(chef_run).to create_template('/opt/easybib/etc/php/xdebug-settings.ini')
  end

  it 'installs php5-easybib-xdebug' do
    expect(chef_run).to install_package('php5-easybib-xdebug')
  end

end
