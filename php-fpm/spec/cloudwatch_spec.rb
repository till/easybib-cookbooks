require 'chefspec'

describe 'php-fpm::cloudwatch' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['instance']['hostname'] = 'host'
  end

  it 'installs awscli' do
    expect(chef_run).to install_package('awscli')
  end

  it 'creates cronjob script' do
    expect(chef_run).to render_file('/opt/easybib/bin/phpfpm-cloudwatch.sh')
      .with_content(
        include('dimensions StackId=Stack')
      )
  end

  it 'inits cronjob' do
    expect(chef_run).to create_cron_d('phpfpm-cloudwatch')
  end
end
