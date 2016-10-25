require_relative 'spec_helper.rb'

describe 'stack-citationapi::role-phpapp' do

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'our basic setup recipe' do
    expect(chef_run).to include_recipe('ies::role-generic')
  end
  it 'installs nginx' do
    expect(chef_run).to include_recipe('nginx-app::server')
  end
  it 'sets up php-fpm' do
    expect(chef_run).to include_recipe('php-fpm')
    expect(chef_run).to include_recipe('php-fpm::ohai')
  end
  %w(phar zlib intl gearman zip zlib opcache).each do |modulename|
    it "installs the php module php::module-#{modulename}" do
      expect(chef_run).to include_recipe("php::module-#{modulename}")
    end
  end
  it 'sets up tideways profiling' do
    expect(chef_run).to include_recipe('tideways')
  end
  it 'sets up composer' do
    # todo
    # node.set['composer']['environment'] = get_deploy_user if is_aws
    expect(chef_run).to include_recipe('composer::configure')
  end
end
