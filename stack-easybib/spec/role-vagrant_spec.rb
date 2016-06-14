require_relative 'spec_helper.rb'

describe 'stack-easybib::role-vagrant' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }

  before do
    node.set['vagrant']['applications']['www'] = {}
  end

  it 'should set up a basic vagrantbox with php and mysql' do
    expect(chef_run).to include_recipe('ies::role-generic')
    expect(chef_run).to include_recipe('ies-mysql')
    expect(chef_run).to include_recipe('ies-mysql::dev')

    expect(chef_run).to include_recipe('ohai')
    expect(chef_run).to include_recipe('memcache')

    expect(chef_run).to include_recipe('stack-easybib::role-phpapp')
    expect(chef_run).to include_recipe('nodejs::npm')
    expect(chef_run).to include_recipe('php::module-pdo_sqlite')
    expect(chef_run).to include_recipe('php::module-xdebug')
  end

  it 'should generate the nginx config for all silex-based apps' do
    expect(chef_run).to include_recipe('nginx-app::vagrant-silex')
  end

  it 'should run the default easybib setup, but use the vagrant config generation' do
    expect(chef_run).to include_recipe('stack-easybib::role-nginxphpapp')
    expect(chef_run).to include_recipe('stack-easybib::deploy-webapps-vagrant')
    expect(chef_run).not_to include_recipe('stack-easybib::deploy-easybib')
    expect(chef_run).to setup_easybib_nginx('www')
      .with(
        :config_template => 'easybib.com.conf.erb'
      )
  end

  it 'should set up gearman daemon and workers' do
    expect(chef_run).to include_recipe('stack-service::role-gearmand')
    expect(chef_run).to include_recipe('stack-easybib::role-gearmanw')
  end
end
