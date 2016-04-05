require 'chefspec'

describe 'php-fpm::cloudwatch' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['instance']['hostname'] = 'host'
  end

  it 'creates cronjob script' do
    expect(chef_run).to render_file("#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh")
      .with_content(
        include('dimensions StackId=stack,InstanceId=host_stack')
      )
  end

  it 'inits cronjob' do
    expect(chef_run).to create_cron_d('phpfpm-cloudwatch')
  end
end
