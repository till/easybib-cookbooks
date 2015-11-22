require_relative 'spec_helper.rb'

describe 'php::module-gearman' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.default['php']['ppa']['package_prefix'] = 'php5-easybib'
    end.converge(described_recipe)
  end

  it 'adds ppa mirror configuration' do
    expect(chef_run).to include_recipe('apt::easybib')
    expect(chef_run).to include_recipe('apt::ppa')
  end

  it 'adds php-fpm service definition' do
    expect(chef_run).to include_recipe('php-fpm::service')
  end

  it 'installs the gearman module' do
    expect(chef_run).to install_package('php5-easybib-gearman')
  end

  it 'reloads php-fpm' do
    package_resource = chef_run.package('php5-easybib-gearman')
    expect(package_resource).to notify('service[php-fpm]').to(:reload).delayed
  end
end
