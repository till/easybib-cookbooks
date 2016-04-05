require 'chefspec'

describe 'php-fpm::cloudwatch' do
  let(:runner) { ChefSpec::Runner.new }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:node) { runner.node }
  let(:conscript_name) { "#{node['php-fpm']['prefix']}/bin/phpfpm-cloudwatch.sh" }

  before do
    node.set['opsworks']['stack']['name'] = 'Stack'
    node.set['opsworks']['instance']['hostname'] = 'host'
    node.set['php-fpm']['cloudwatch'] = true
  end

  it 'creates cronjob script' do
    expect(chef_run).to render_file(conscript_name)
      .with_content(
        include('dimensions StackId=stack,InstanceId=host_stack')
      )
  end

  it 'notifies cron_d create' do
    conscript_resource = chef_run.template(conscript_name)
    expect(conscript_resource).to notify('cron_d[phpfpm-cloudwatch]')
      .to(:create)
      .immediately
  end
end
