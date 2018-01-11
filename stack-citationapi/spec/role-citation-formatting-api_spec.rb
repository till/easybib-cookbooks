require_relative 'spec_helper.rb'

describe 'stack-citationapi::role-formatting-api' do

  let(:runner)   { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node)     { runner.node }
  before do
    stub_command('php -m | grep redis').and_return(true)
  end
  before do
    node.override['opsworks']['stack']['name'] = 'Stack'
    node.override['opsworks']['instance']['layers'] = ['bibapi']
    node.override['opsworks']['instance']['hostname'] = 'host'
    node.override['opsworks']['instance']['ip'] = '127.0.0.1'
    node.override['deploy']['easybib_api'] = {
      'deploy_to' => '/srv/www/bibapi',
      'document_root' => 'public'
    }
  end

  it 'installs a php server' do
    expect(chef_run).to include_recipe('stack-citationapi::role-phpapp')
  end

  it 'starts the app deployment' do
    expect(chef_run).to include_recipe('stack-citationapi::deploy-citationapi')
  end

  it 'creates the nginx config with the correct template' do
    expect(chef_run).to setup_easybib_nginx('easybib_api')
      .with(
        :config_template => 'default-web-nginx.conf.erb'
      )
  end

end
